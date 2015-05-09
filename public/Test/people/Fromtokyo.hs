{-# LANGUAGE DeriveGeneric #-}
module Fromtokyo where

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


newtype Fromtokyo = Fromtokyo [Fromtokyo.Name] 		deriving (Eq,Show,Generic)
newtype Name = Name Str 		deriving (Eq,Show,Generic)
instance HTypeable Fromtokyo.Fromtokyo where
    toHType x = Defined "fromtokyo" [] []
instance XmlContent Fromtokyo.Fromtokyo where
    toContents (Fromtokyo.Fromtokyo a) =
        [CElem (Elem (N "fromtokyo") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["fromtokyo"]
        ; interior e $ return (Fromtokyo.Fromtokyo)
                       `apply` many parseContents
        } `adjustErr` ("in <fromtokyo>, "++)
instance HTypeable Fromtokyo.Name where
    toHType x = Defined "name" [] []
instance XmlContent Fromtokyo.Name where
    toContents (Fromtokyo.Name a) =
        [CElem (Elem (N "name") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["name"]
        ; interior e $ return (Fromtokyo.Name)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <name>, "++)
instance Typeable Fromtokyo.Fromtokyo where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "fromtokyo" "Fromtokyo") typeof
instance Typeable Fromtokyo.Name where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "name" "Name") typeof

typeEnv = Map.insert "fromtokyo" (DynT (typeof :: Type (Fromtokyo.Fromtokyo))) (Map.insert "name" (DynT (typeof :: Type (Fromtokyo.Name))) (Map.empty))
