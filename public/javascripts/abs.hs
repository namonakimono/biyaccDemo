{-# LANGUAGE DeriveGeneric #-}
module Abstract where

import Data.Map (Map(..))
import qualified Data.Map as Map
import Text.XML.HaXml.XmlContent hiding (List1)
import Text.XML.HaXml.Types
import Text.XML.BiFluX.DTD.HaXml.TypeDef
import Text.XML.BiFluX.DTD.Type
import Text.XML.HaXml.DtdToHaskell.TypeDef (Name(..))
import Control.Monad
import GHC.Generics as Generics

type EMPTY = ()


data Arith = ArithAdd Abstract.Add
           | ArithSub Abstract.Sub
           | ArithMul Abstract.Mul
           | ArithDiv Abstract.Div
           | ArithANum Abstract.ANum
           deriving (Eq,Show,Generic)
data Add = Add Abstract.Arith Abstract.Arith
         deriving (Eq,Show,Generic)
data Sub = Sub Abstract.Arith Abstract.Arith
         deriving (Eq,Show,Generic)
data Mul = Mul Abstract.Arith Abstract.Arith
         deriving (Eq,Show,Generic)
data Div = Div Abstract.Arith Abstract.Arith
         deriving (Eq,Show,Generic)
newtype ANum = ANum Abstract.Biyaccpcdata 		deriving (Eq,Show,Generic)
newtype Biyaccpcdata = Biyaccpcdata Str 		deriving (Eq,Show,Generic)
instance HTypeable Abstract.Arith where
    toHType x = Defined "arith" [] []
instance XmlContent Abstract.Arith where
    toContents (Abstract.ArithAdd a) =
        [CElem (Elem (N "arith") [] (toContents a) ) ()]
    toContents (Abstract.ArithSub a) =
        [CElem (Elem (N "arith") [] (toContents a) ) ()]
    toContents (Abstract.ArithMul a) =
        [CElem (Elem (N "arith") [] (toContents a) ) ()]
    toContents (Abstract.ArithDiv a) =
        [CElem (Elem (N "arith") [] (toContents a) ) ()]
    toContents (Abstract.ArithANum a) =
        [CElem (Elem (N "arith") [] (toContents a) ) ()]
    parseContents = do 
        { e@(Elem _ [] _) <- element ["arith"]
        ; interior e $ oneOf
            [ return (Abstract.ArithAdd) `apply` parseContents
            , return (Abstract.ArithSub) `apply` parseContents
            , return (Abstract.ArithMul) `apply` parseContents
            , return (Abstract.ArithDiv) `apply` parseContents
            , return (Abstract.ArithANum) `apply` parseContents
            ] `adjustErr` ("in <arith>, "++)
        }
instance HTypeable Abstract.Add where
    toHType x = Defined "add" [] []
instance XmlContent Abstract.Add where
    toContents (Abstract.Add a b) =
        [CElem (Elem (N "add") [] (toContents a ++ toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["add"]
        ; interior e $ return (Abstract.Add) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <add>, "++)
instance HTypeable Abstract.Sub where
    toHType x = Defined "sub" [] []
instance XmlContent Abstract.Sub where
    toContents (Abstract.Sub a b) =
        [CElem (Elem (N "sub") [] (toContents a ++ toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["sub"]
        ; interior e $ return (Abstract.Sub) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <sub>, "++)
instance HTypeable Abstract.Mul where
    toHType x = Defined "mul" [] []
instance XmlContent Abstract.Mul where
    toContents (Abstract.Mul a b) =
        [CElem (Elem (N "mul") [] (toContents a ++ toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["mul"]
        ; interior e $ return (Abstract.Mul) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <mul>, "++)
instance HTypeable Abstract.Div where
    toHType x = Defined "div" [] []
instance XmlContent Abstract.Div where
    toContents (Abstract.Div a b) =
        [CElem (Elem (N "div") [] (toContents a ++ toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["div"]
        ; interior e $ return (Abstract.Div) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <div>, "++)
instance HTypeable Abstract.ANum where
    toHType x = Defined "num" [] []
instance XmlContent Abstract.ANum where
    toContents (Abstract.ANum a) =
        [CElem (Elem (N "num") [] (toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["num"]
        ; interior e $ return (Abstract.ANum) `apply` parseContents
        } `adjustErr` ("in <num>, "++)
instance HTypeable Abstract.Biyaccpcdata where
    toHType x = Defined "biyaccpcdata" [] []
instance XmlContent Abstract.Biyaccpcdata where
    toContents (Abstract.Biyaccpcdata a) =
        [CElem (Elem (N "biyaccpcdata") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["biyaccpcdata"]
        ; interior e $ return (Abstract.Biyaccpcdata)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <biyaccpcdata>, "++)
instance Typeable Abstract.Arith where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "arith" "Arith") typeof
instance Typeable Abstract.Add where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "add" "Add") typeof
instance Typeable Abstract.Sub where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "sub" "Sub") typeof
instance Typeable Abstract.Mul where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "mul" "Mul") typeof
instance Typeable Abstract.Div where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "div" "Div") typeof
instance Typeable Abstract.ANum where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "num" "ANum") typeof
instance Typeable Abstract.Biyaccpcdata where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "biyaccpcdata" "Biyaccpcdata") typeof

typeEnv = Map.insert "arith" (DynT (typeof :: Type (Abstract.Arith))) (Map.insert "add" (DynT (typeof :: Type (Abstract.Add))) (Map.insert "sub" (DynT (typeof :: Type (Abstract.Sub))) (Map.insert "mul" (DynT (typeof :: Type (Abstract.Mul))) (Map.insert "div" (DynT (typeof :: Type (Abstract.Div))) (Map.insert "num" (DynT (typeof :: Type (Abstract.ANum))) (Map.insert "biyaccpcdata" (DynT (typeof :: Type (Abstract.Biyaccpcdata))) (Map.empty)))))))

xmlTypeEnv = Map.insert "arith" (XmlT (typeof :: Type (Abstract.Arith))) (Map.insert "add" (XmlT (typeof :: Type (Abstract.Add))) (Map.insert "sub" (XmlT (typeof :: Type (Abstract.Sub))) (Map.insert "mul" (XmlT (typeof :: Type (Abstract.Mul))) (Map.insert "div" (XmlT (typeof :: Type (Abstract.Div))) (Map.insert "num" (XmlT (typeof :: Type (Abstract.ANum))) (Map.insert "biyaccpcdata" (XmlT (typeof :: Type (Abstract.Biyaccpcdata))) (Map.empty)))))))
