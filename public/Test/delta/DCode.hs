{-# LANGUAGE DeriveGeneric #-}
module DCode where

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


newtype Code = Code [(Either DCode.If DCode.Assignment)] 		deriving (Eq,Show,Generic)
data If = If DCode.Condition DCode.Code (Mb DCode.Else)
        deriving (Eq,Show,Generic)
newtype Condition = Condition Str 		deriving (Eq,Show,Generic)
newtype Else = Else DCode.Code 		deriving (Eq,Show,Generic)
data Assignment = Assignment DCode.Left DCode.Right
                deriving (Eq,Show,Generic)
newtype Left = Left Str 		deriving (Eq,Show,Generic)
newtype Right = Right Str 		deriving (Eq,Show,Generic)
instance HTypeable DCode.Code where
    toHType x = Defined "code" [] []
instance XmlContent DCode.Code where
    toContents (DCode.Code a) =
        [CElem (Elem (N "code") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["code"]
        ; interior e $ return (DCode.Code) `apply` many parseContents
        } `adjustErr` ("in <code>, "++)
instance HTypeable DCode.If where
    toHType x = Defined "if" [] []
instance XmlContent DCode.If where
    toContents (DCode.If a b c) =
        [CElem (Elem (N "if") [] (toContents a ++ toContents b ++
                                  maybeMb [] toContents c)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["if"]
        ; interior e $ return (DCode.If) `apply` parseContents
                       `apply` parseContents `apply` optionalMb parseContents
        } `adjustErr` ("in <if>, "++)
instance HTypeable DCode.Condition where
    toHType x = Defined "condition" [] []
instance XmlContent DCode.Condition where
    toContents (DCode.Condition a) =
        [CElem (Elem (N "condition") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["condition"]
        ; interior e $ return (DCode.Condition)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <condition>, "++)
instance HTypeable DCode.Else where
    toHType x = Defined "else" [] []
instance XmlContent DCode.Else where
    toContents (DCode.Else a) =
        [CElem (Elem (N "else") [] (toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["else"]
        ; interior e $ return (DCode.Else) `apply` parseContents
        } `adjustErr` ("in <else>, "++)
instance HTypeable DCode.Assignment where
    toHType x = Defined "assignment" [] []
instance XmlContent DCode.Assignment where
    toContents (DCode.Assignment a b) =
        [CElem (Elem (N "assignment") [] (toContents a ++
                                          toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["assignment"]
        ; interior e $ return (DCode.Assignment) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <assignment>, "++)
instance HTypeable DCode.Left where
    toHType x = Defined "left" [] []
instance XmlContent DCode.Left where
    toContents (DCode.Left a) =
        [CElem (Elem (N "left") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["left"]
        ; interior e $ return (DCode.Left)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <left>, "++)
instance HTypeable DCode.Right where
    toHType x = Defined "right" [] []
instance XmlContent DCode.Right where
    toContents (DCode.Right a) =
        [CElem (Elem (N "right") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["right"]
        ; interior e $ return (DCode.Right)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <right>, "++)
instance Typeable DCode.Code where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "code" "Code") typeof
instance Typeable DCode.If where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "if" "If") typeof
instance Typeable DCode.Condition where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "condition" "Condition") typeof
instance Typeable DCode.Else where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "else" "Else") typeof
instance Typeable DCode.Assignment where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "assignment" "Assignment") typeof
instance Typeable DCode.Left where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "left" "Left") typeof
instance Typeable DCode.Right where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "right" "Right") typeof

typeEnv = Map.insert "code" (DynT (typeof :: Type (DCode.Code))) (Map.insert "if" (DynT (typeof :: Type (DCode.If))) (Map.insert "condition" (DynT (typeof :: Type (DCode.Condition))) (Map.insert "else" (DynT (typeof :: Type (DCode.Else))) (Map.insert "assignment" (DynT (typeof :: Type (DCode.Assignment))) (Map.insert "left" (DynT (typeof :: Type (DCode.Left))) (Map.insert "right" (DynT (typeof :: Type (DCode.Right))) (Map.empty)))))))
