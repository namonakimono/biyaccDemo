import Control.Arrow ((***))
import Control.Monad
import Data.Char (isSpace)
import Data.Maybe
-- import Data.Either
import Text.ParserCombinators.Parsec hiding ((<+>))
import Text.ParserCombinators.Parsec.Pos
import Text.PrettyPrint (Doc, ($+$), (<>), (<+>), text, nest, parens, render)
import qualified Text.PrettyPrint as PP
import System.Process (readProcess)
import System.IO (readFile, writeFile)
import System.Environment (getArgs)


-- Source

data Expr = EAdd Expr Term
          | ESub Expr Term
          | ET Term
  deriving Show

data Term = TMul Term Factor
          | TDiv Term Factor
          | TF Factor
  deriving Show

data Factor = FNum Int
            | FNeg Factor
            | FE Expr
  deriving Show

-- View

-- data Arith = Add Arith Arith
--            | Sub Arith Arith
--            | Mul Arith Arith
--            | Num Int


--------
-- Parsers

(>|>=) :: Monad m => m a -> (a -> m b) -> m a
(>|>=) mx f = mx >>= \x -> f x >> return x

(>|>) :: Monad m => m a -> m b -> m a
(>|>) mx my = mx >|>= const my

alternatives :: [GenParser tok st a] -> GenParser tok st a
alternatives = foldr1 ((<|>) . try)

data ExprToken = Lit Int | AddOp | SubOp | MulOp | DivOp | LParen | RParen deriving (Eq, Show)

exprTokeniser :: Parser ExprToken
exprTokeniser =
  alternatives
    [liftM (Lit . read) (many1 digit),
     char '+' >> return AddOp,
     char '-' >> return SubOp,
     char '*' >> return MulOp,
     char '/' >> return DivOp,
     char '(' >> return LParen,
     char ')' >> return RParen]

lit :: GenParser ExprToken () Int
lit = token show (const (initialPos "")) (\t -> case t of { Lit n -> Just n; _ -> Nothing })

exprToken :: ExprToken -> GenParser ExprToken () ExprToken
exprToken tok = token show (const (initialPos "")) (\t -> if t == tok then Just tok else Nothing)

exprParser :: GenParser ExprToken () Expr
exprParser =
  liftM (either ET id)
    (chainl1
       (liftM Left termParser)
       (liftM (\op -> f (if op == AddOp then EAdd else ESub))
              (alternatives [exprToken AddOp, exprToken SubOp])))
  where
    f :: (Expr -> Term -> Expr) -> Either Term Expr -> Either Term Expr -> Either Term Expr
    f con (Left  lhsTerm) (Left rhsTerm) = Right (con (ET lhsTerm) rhsTerm)
    f con (Right lhsExpr) (Left rhsTerm) = Right (con lhsExpr rhsTerm)
    f con _               (Right _     ) = error "exprParser: the impossible happened"

termParser :: GenParser ExprToken () Term
termParser =
  liftM (either TF id)
    (chainl1
      (liftM Left factorParser)
      (liftM (\op -> f (if op == MulOp then TMul else TDiv))
        (alternatives [exprToken MulOp, exprToken DivOp])))
  where
      f :: (Term -> Factor -> Term) -> Either Factor Term -> Either Factor Term -> Either Factor Term
      f con (Left  lhsFactor) (Left rhsFactor) = Right (con (TF lhsFactor) rhsFactor)
      f con (Right lhsTerm  ) (Left rhsFactor) = Right (con lhsTerm rhsFactor)
      f con _                 (Right _       ) = error "factorParser: the impossible happened"

factorParser :: GenParser ExprToken () Factor
factorParser =
  alternatives
    [liftM FNum lit,
     exprToken SubOp >> liftM FNeg factorParser,
     exprToken LParen >> (liftM FE exprParser >|> exprToken RParen)]

data XMLToken = Begin String | End String | PCData String deriving Show

xmlTokeniser :: Parser XMLToken
xmlTokeniser =
  alternatives
    [char '<' >> spaces >>
       alternatives
         [char '/' >> spaces >>
            (liftM End (many1 (satisfy (\c -> not (isSpace c || c == '>')))) >|>
               (spaces >> char '>')),
          liftM Begin (many1 (satisfy (\c -> not (isSpace c || c == '>')))) >|> (spaces >> char '>')],
     liftM PCData (many1 (satisfy (/= '<')))]

beginElement :: String -> GenParser XMLToken () ()
beginElement name = token show (const (initialPos ""))
                      (\t -> case t of { Begin s -> if s == name then Just () else Nothing; _ -> Nothing })

endElement :: String -> GenParser XMLToken () ()
endElement name = token show (const (initialPos ""))
                    (\t -> case t of { End s -> if s == name then Just () else Nothing; _ -> Nothing })

pcdata :: GenParser XMLToken () String
pcdata = token show (const (initialPos "")) (\t -> case t of { PCData s -> Just s; _ -> Nothing })

xmlExprParser :: GenParser XMLToken () Expr
xmlExprParser =
  beginElement "expr" >>
    (alternatives
       [beginElement "a0" >> (liftM2 EAdd xmlExprParser xmlTermParser >|> endElement "a0"),
        beginElement "a1" >> (liftM2 ESub xmlExprParser xmlTermParser >|> endElement "a1"),
        beginElement "a2" >> (liftM ET xmlTermParser >|> endElement "a2")] >|>
       endElement "expr")

xmlTermParser :: GenParser XMLToken () Term
xmlTermParser =
  beginElement "term" >>
    (alternatives
       [beginElement "a3" >> (liftM2 TMul xmlTermParser xmlFactorParser >|> endElement "a3"),
        beginElement "a4" >> (liftM2 TDiv xmlTermParser xmlFactorParser >|> endElement "a4"),
        beginElement "a5" >> (liftM TF xmlFactorParser >|> endElement "a5")] >|>
       endElement "term")

xmlFactorParser :: GenParser XMLToken () Factor
xmlFactorParser = do
  beginElement "factor" >>
    (alternatives
       [beginElement "a6" >> (liftM FNeg xmlFactorParser >|> endElement "a6"),
        beginElement "a7" >> beginElement "biyaccpcdata" >> (liftM (FNum . read) pcdata>>=
          \num -> endElement "biyaccpcdata" >> endElement "a7" >> return num),
        beginElement "a8" >> (liftM FE xmlExprParser >|> endElement "a8")] >|>
       endElement "factor")

tokeniseAndParse :: Parser tok -> GenParser tok () a -> String -> Either ParseError a
tokeniseAndParse tokeniser parser = (parse parser "" =<<) . parse (spaces >> (many (tokeniser >|> spaces) >|> eof)) ""


--------
-- Pra2ty-printers

docExpr :: Expr -> Doc
docExpr (EAdd expr term) = docExpr expr <+> PP.char '+' <+> docTerm term
docExpr (ESub expr term) = docExpr expr <+> PP.char '-' <+> docTerm term
docExpr (ET term) = docTerm term

docTerm :: Term -> Doc
docTerm (TMul term factor) = docTerm term <+> PP.char '*' <+> docFactor factor
docTerm (TDiv term factor) = docTerm term <+> PP.char '/' <+> docFactor factor
docTerm (TF factor) = docFactor factor

docFactor :: Factor -> Doc
docFactor (FNeg factor) = PP.char '-' <> docFactor factor
docFactor (FNum n) = text (show n)
docFactor (FE expr) = parens (docExpr expr)

xmlExpr :: Expr -> Doc
xmlExpr expr = text "<expr>" $+$ nest 2 (xmlExpr' expr) $+$ text "</expr>"
  where
    xmlExpr' :: Expr -> Doc
    xmlExpr' (EAdd expr term) = text "<a0>" $+$ nest 2 (xmlExpr expr $+$ xmlTerm term) $+$ text "</a0>"
    xmlExpr' (ESub expr term) = text "<a1>" $+$ nest 2 (xmlExpr expr $+$ xmlTerm term) $+$ text "</a1>"
    xmlExpr' (ET term) = text "<a2>" $+$ nest 2 (xmlTerm term) $+$ text "</a2>"

xmlTerm :: Term -> Doc
xmlTerm term = text "<term>" $+$ nest 2 (xmlTerm' term) $+$ text "</term>"
  where
    xmlTerm' :: Term -> Doc
    xmlTerm' (TMul term factor) = text "<a3>" $+$ nest 2 (xmlTerm term $+$ xmlFactor factor) $+$ text "</a3>"
    xmlTerm' (TDiv term factor) = text "<a4>" $+$ nest 2 (xmlTerm term $+$ xmlFactor factor) $+$ text "</a4>"
    xmlTerm' (TF factor) = text "<a5>" $+$ nest 2 (xmlFactor factor) $+$ text "</a5>"

xmlFactor :: Factor -> Doc
xmlFactor factor = text "<factor>" $+$ nest 2 (xmlFactor' factor) $+$ text "</factor>"
  where
    xmlFactor' :: Factor -> Doc
    xmlFactor' (FNeg factor) = text "<a6>" $+$ nest 2 (xmlFactor factor) $+$ text "</a6>"
    xmlFactor' (FNum n) = text "<a7><biyaccpcdata>" <> text (show n) <> text "</biyaccpcdata></a7>"
    xmlFactor' (FE expr) = text "<a8>" $+$ nest 2 (xmlExpr expr) $+$ text "</a8>"


--------
-- utility functions

parseExpr :: String -> Either ParseError Expr
parseExpr = tokeniseAndParse exprTokeniser exprParser

toXML :: String -> Either ParseError String
toXML = fmap (render . xmlExpr) . parseExpr

printXML :: String -> IO ()
printXML = putStrLn . either show id . toXML

copyXML :: String -> IO ()
copyXML = either (putStrLn . show) ((putStrLn =<<) . readProcess "pbcopy" []) . toXML

pasteXML :: IO ()
pasteXML = pasteXML' >>= putStrLn

pasteXML' :: IO String
pasteXML' = liftM (either show (render . docExpr) . tokeniseAndParse xmlTokeniser xmlExprParser)
                  (readProcess "pbpaste" [] "")

xml2Str :: String -> String -> IO ()
xml2Str infname outfname= do
  raw_xml <- readFile infname
  let xml = unlines . tail . lines $ raw_xml
      str = (either show (render . docExpr) . tokeniseAndParse xmlTokeniser xmlExprParser) xml
  writeFile outfname str

str2XML :: String -> String -> IO ()
str2XML infname outfname = do
  str <- readFile infname
  putStrLn "reads a string:"
  putStrLn str
  case isEmptyStr str of
    False -> do
      case toXML str of
        Left errmsg -> error (show errmsg)
        Right xml -> do
          writeFile (outfname ++ "temp") xml
          pprintedxml <- readProcess "xmllint" ["--format", outfname ++ "temp"] []
          writeFile outfname pprintedxml
          readProcess "rm" [outfname ++ "temp"] []
          return ()
    True -> do
      writeFile (outfname ++ "temp") "<expr><null/></expr>"
      pprintedxml <- readProcess "xmllint" ["--format", outfname ++ "temp"] []
      writeFile outfname pprintedxml
      readProcess "rm" [outfname ++ "temp"] []
      return ()

main :: IO()
main = do
  args <- getArgs
  case length args of
    3 -> do
      case args !! 0 of
        "-p"  -> do
          let stringFile = args !! 1
              xmlFile = args !! 2
          str2XML stringFile xmlFile
        "-pp" -> do
          let stringFile = args !! 2
              xmlFile = args !! 1
          xml2Str xmlFile stringFile
    _ -> error $ "usage: exprppp -p stringFile XMLFile\n" ++
                 "exprppp -pp XMLFile stringFile\n" ++
                 "-p: parser; -pp: pretty print. please specify the stringFile and XMLFile"

isEmptyStr :: String -> Bool
isEmptyStr str =
  case filt str of
    "" -> True
    _  -> False
  where
    filt :: String -> String
    filt = filter (/= ' ') . filter (/= '\t') . filter (/= '\n') . filter (/= '\r')
