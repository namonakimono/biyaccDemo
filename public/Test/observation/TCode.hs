{-# LANGUAGE DeriveGeneric #-}
module TCode where

import Data.Map (Map(..))
import qualified Data.Map as Map
import Text.XML.HaXml.XmlContent hiding (List1)
import Text.XML.HaXml.Types
import Text.XML.PutXML.DTD.HaXml.TypeDef
import Text.XML.PutXML.DTD.Type
import Text.XML.HaXml.DtdToHaskell.TypeDef (Name(..))
import Control.Monad
import GHC.Generics as Generics

type EMPTY = ()


newtype Returns = Returns [TCode.If] 		deriving (Eq,Show,Generic)
data If = If TCode.Condition TCode.Code (Mb TCode.Else)
        deriving (Eq,Show,Generic)
newtype Condition = Condition Str 		deriving (Eq,Show,Generic)
data Code = CodeReturn TCode.Return
          | CodeThrow TCode.Throw
          deriving (Eq,Show,Generic)
newtype Else = Else TCode.Code 		deriving (Eq,Show,Generic)
newtype Throw = Throw Str 		deriving (Eq,Show,Generic)
newtype Return = Return Str 		deriving (Eq,Show,Generic)
instance HTypeable TCode.Returns where
    toHType x = Defined "returns" [] []
instance XmlContent TCode.Returns where
    toContents (TCode.Returns a) =
        [CElem (Elem (N "returns") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["returns"]
        ; interior e $ return (TCode.Returns) `apply` many parseContents
        } `adjustErr` ("in <returns>, "++)
instance HTypeable TCode.If where
    toHType x = Defined "if" [] []
instance XmlContent TCode.If where
    toContents (TCode.If a b c) =
        [CElem (Elem (N "if") [] (toContents a ++ toContents b ++
                                  maybeMb [] toContents c)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["if"]
        ; interior e $ return (TCode.If) `apply` parseContents
                       `apply` parseContents `apply` optionalMb parseContents
        } `adjustErr` ("in <if>, "++)
instance HTypeable TCode.Condition where
    toHType x = Defined "condition" [] []
instance XmlContent TCode.Condition where
    toContents (TCode.Condition a) =
        [CElem (Elem (N "condition") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["condition"]
        ; interior e $ return (TCode.Condition)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <condition>, "++)
instance HTypeable TCode.Code where
    toHType x = Defined "code" [] []
instance XmlContent TCode.Code where
    toContents (TCode.CodeReturn a) =
        [CElem (Elem (N "code") [] (toContents a) ) ()]
    toContents (TCode.CodeThrow a) =
        [CElem (Elem (N "code") [] (toContents a) ) ()]
    parseContents = do 
        { e@(Elem _ [] _) <- element ["code"]
        ; interior e $ oneOf
            [ return (TCode.CodeReturn) `apply` parseContents
            , return (TCode.CodeThrow) `apply` parseContents
            ] `adjustErr` ("in <code>, "++)
        }
instance HTypeable TCode.Else where
    toHType x = Defined "else" [] []
instance XmlContent TCode.Else where
    toContents (TCode.Else a) =
        [CElem (Elem (N "else") [] (toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["else"]
        ; interior e $ return (TCode.Else) `apply` parseContents
        } `adjustErr` ("in <else>, "++)
instance HTypeable TCode.Throw where
    toHType x = Defined "throw" [] []
instance XmlContent TCode.Throw where
    toContents (TCode.Throw a) =
        [CElem (Elem (N "throw") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["throw"]
        ; interior e $ return (TCode.Throw)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <throw>, "++)
instance HTypeable TCode.Return where
    toHType x = Defined "return" [] []
instance XmlContent TCode.Return where
    toContents (TCode.Return a) =
        [CElem (Elem (N "return") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["return"]
        ; interior e $ return (TCode.Return)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <return>, "++)
instance Typeable TCode.Returns where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "returns" "Returns") typeof
instance Typeable TCode.If where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "if" "If") typeof
instance Typeable TCode.Condition where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "condition" "Condition") typeof
instance Typeable TCode.Code where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "code" "Code") typeof
instance Typeable TCode.Else where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "else" "Else") typeof
instance Typeable TCode.Throw where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "throw" "Throw") typeof
instance Typeable TCode.Return where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "return" "Return") typeof

typeEnv = Map.insert "returns" (DynT (typeof :: Type (TCode.Returns))) (Map.insert "if" (DynT (typeof :: Type (TCode.If))) (Map.insert "condition" (DynT (typeof :: Type (TCode.Condition))) (Map.insert "code" (DynT (typeof :: Type (TCode.Code))) (Map.insert "else" (DynT (typeof :: Type (TCode.Else))) (Map.insert "throw" (DynT (typeof :: Type (TCode.Throw))) (Map.insert "return" (DynT (typeof :: Type (TCode.Return))) (Map.empty)))))))
