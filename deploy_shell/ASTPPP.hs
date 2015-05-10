{-# LANGUAGE OverloadedStrings #-}

import Text.Parsec
import Text.Parsec.Char
import qualified Text.Parsec.Char as PC (char)
import Text.Parsec.Combinator
import qualified Text.Parsec.Token as PT

import System.IO
import System.Environment
import System.Process

import Text.PrettyPrint

astTypeDef = PT.LanguageDef
  {
    PT.commentStart = ""
   ,PT.commentEnd = ""
   ,PT.commentLine =""
   ,PT.nestedComments = False
   ,PT.identStart = upper
   ,PT.identLetter = alphaNum
   ,PT.opStart = oneOf ":!#$%&*+./<=>?@\\^|-~"
   ,PT.opLetter = oneOf ":!#$%&*+./<=>?@\\^|-~"
   ,PT.reservedNames = []
   ,PT.reservedOpNames = [""]
   ,PT.caseSensitive = False
  }

tokenParser = PT.makeTokenParser astTypeDef
lexeme = PT.lexeme tokenParser
whiteSpace = PT.whiteSpace tokenParser

type PSE = Parsec String ()
type PSEA = Parsec String () Arith


data Arith = ADD Arith Arith
           | SUB Arith Arith
           | MUL Arith Arith
           | DIV Arith Arith
           | NUM BiyaccPCDATA
  deriving (Show, Eq)

data BiyaccPCDATA = BiyaccPCDATA String deriving (Show, Eq)

-- instance Show Arith where
--   show (ADD lhs rhs) = "ADD" ++ "\n  (" ++ show lhs ++ ")\n  (" ++ show rhs ++ ")"
--   show (SUB lhs rhs) = "SUB" ++ "\n  (" ++ show lhs ++ ")\n  (" ++ show rhs ++ ")"
--   show (MUL lhs rhs) = "MUL" ++ "\n  (" ++ show lhs ++ ")\n  (" ++ show rhs ++ ")"
--   show (DIV lhs rhs) = "DIV" ++ "\n  (" ++ show lhs ++ ")\n  (" ++ show rhs ++ ")"
--   show (NUM pcdata)      = "NUM " ++ show pcdata

-- instance Show BiyaccPCDATA where
--   show (BiyaccPCDATA str) = show str



parsexml :: PSEA
parsexml = whiteSpace >> optional (try $ string "<?xml version=\"1.0\"?>") >> whiteSpace >> arithTP <?> "parsexml"
-- parsexml = whiteSpace >> arithTP <?> "parsexml"

string1 :: String -> PSE ()
string1 str = string str >> whiteSpace

arithTP :: PSEA
arithTP = lexeme (do
  string1 "<arith>"
  arith <- foldr1 ((<|>) . try) [addTP, subTP, mulTP, divTP, numTP]
  string1 "</arith>"
  return arith
  <?> "arithTP")

addTP :: PSEA
addTP = lexeme (do
  string1 "<add>"
  lhs <- arithTP
  rhs <- arithTP
  string1 "</add>"
  return $ ADD lhs rhs
  <?> "addTP")

subTP :: PSEA
subTP = lexeme (do
  string1 "<sub>"
  lhs <- arithTP
  rhs <- arithTP
  string1 "</sub>"
  return $ SUB lhs rhs
  <?> "subTP")

mulTP :: PSEA
mulTP = lexeme (do
  string1 "<mul>"
  lhs <- arithTP
  rhs <- arithTP
  string1 "</mul>"
  return $ MUL lhs rhs
  <?> "mulTP")

divTP :: PSEA
divTP = lexeme (do
  string1 "<div>"
  lhs <- arithTP
  rhs <- arithTP
  string1 "</div>"
  return $ DIV lhs rhs
  <?> "divTP")

numTP :: PSEA
numTP = lexeme (do
  string1 "<num>"
  pcdata <- pcdataTP
  string1 "</num>"
  return $ NUM pcdata
  <?> "numTP")

pcdataTP :: PSE BiyaccPCDATA
pcdataTP = lexeme (do
  num <- between (string1 "<biyaccpcdata>") (string1 "</biyaccpcdata>") (many alphaNum)
  return $ BiyaccPCDATA num
  <?> "pcdataTP")

ppast :: Arith -> Doc
ppast (ADD lhs rhs) = text "ADD" $+$ nest2 (parens (ppast lhs) $+$ parens (ppast rhs))
ppast (SUB lhs rhs) = text "SUB" $+$ nest2 (parens (ppast lhs) $+$ parens (ppast rhs))
ppast (MUL lhs rhs) = text "MUL" $+$ nest2 (parens (ppast lhs) $+$ parens (ppast rhs))
ppast (DIV lhs rhs) = text "DIV" $+$ nest2 (parens (ppast lhs) $+$ parens (ppast rhs))
ppast (NUM (BiyaccPCDATA str))  = text "NUM" <+> text str


parsestr :: PSEA
parsestr = whiteSpace >> arithTPr

-- 'r' means it is like a reverse of (arithTP)
arithTPr :: PSEA
arithTPr = foldr1 ((<|>) . try) [arithParen, addTPr, subTPr, mulTPr, divTPr, numTPr]

arithParen :: PSEA
arithParen = lexeme (PC.char '(' >> arithTPr >>= \val -> PC.char ')' >> return val <?> "arithParen")


addTPr :: PSEA
addTPr = lexeme (do
  string1 "ADD"; lhs <- arithTPr; rhs <- arithTPr; return $ ADD lhs rhs
  <?> "addTPr")

subTPr :: PSEA
subTPr = lexeme (do
  string1 "SUB"; lhs <- arithTPr; rhs <- arithTPr; return $ SUB lhs rhs
  <?> "subTPr")

mulTPr :: PSEA
mulTPr = lexeme (do
  string1 "MUL"; lhs <- arithTPr; rhs <- arithTPr; return $ MUL lhs rhs
  <?> "mulTPr")

divTPr :: PSEA
divTPr = lexeme (do
  string1 "DIV"; lhs <- arithTPr; rhs <- arithTPr; return $ DIV lhs rhs
  <?> "divTPr")

numTPr :: PSEA
numTPr = lexeme (do
  string1 "NUM"; num <- many alphaNum; return $ NUM (BiyaccPCDATA num)
  <?> "numTPr")

ppast2XML :: Arith -> Doc
ppast2XML (ADD lhs rhs) = wrapTag "arith" (wrapTag "add" $ ppast2XML lhs $+$ ppast2XML rhs)
ppast2XML (SUB lhs rhs) = wrapTag "arith" (wrapTag "sub" $ ppast2XML lhs $+$ ppast2XML rhs)
ppast2XML (MUL lhs rhs) = wrapTag "arith" (wrapTag "mul" $ ppast2XML lhs $+$ ppast2XML rhs)
ppast2XML (DIV lhs rhs) = wrapTag "arith" (wrapTag "div" $ ppast2XML lhs $+$ ppast2XML rhs)
ppast2XML (NUM (BiyaccPCDATA num)) = wrapTag "arith" (wrapTag "num" ("<biyaccpcdata>" <> text num <> "</biyaccpcdata>" ))

addXMLheader :: Doc -> Doc
addXMLheader = ($+$) "<?xml version=\"1.0\"?>"



wrapTag :: String -> Doc -> Doc
wrapTag tagname doc =
  "<" <> text tagname <> ">" $+$ (nest2 doc $+$ ("</" <> text tagname <> ">"))


nest2 :: Doc -> Doc
nest2 = nest 2

nestn2 :: Doc -> Doc
nestn2 = nest (-2)

main :: IO ()
main = do
  args <- getArgs
  case length args of
    3 -> do
      case args !! 0 of
        "-p"  -> do
          let astFile = args !! 1
              xmlFile = args !! 2
          ast2xml astFile xmlFile
        "-pp" -> do
          let astFile = args !! 2
              xmlFile = args !! 1
          xml2ast xmlFile astFile
    _ -> error $ "usage: exprppp -p stringFile XMLFile\n" ++
                 "exprppp -pp XMLFile stringFile\n" ++
                 "-p: parser; -pp: pretty print. please specify the stringFile and XMLFile"

xml2ast :: String -> String -> IO ()
xml2ast infname outfname= do
  raw_xml <- readFile infname
  let xml = unlines . tail . lines $ raw_xml
      east = parse parsexml infname xml
  case east of
    Left errmsg -> print errmsg
    Right ast -> do
      -- putStrLn (render . ppast $ ast)
      writeFile outfname (render . ppast $ ast)

ast2xml :: String -> String -> IO ()
ast2xml infname outfname = do
  raw <- readFile infname
  case parse parsestr infname raw of
    Left errmsg -> error $ show errmsg
    Right ast ->
      -- putStrLn . render . ppast2XML $ ast
      writeFile outfname (render . addXMLheader . ppast2XML $ ast)
