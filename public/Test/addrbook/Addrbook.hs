{-# LANGUAGE DeriveGeneric #-}
module Addrbook where

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


newtype Addrbook = Addrbook [Addrbook.Person] 		deriving (Eq,Show,Generic)
data Person = Person Addrbook.Name (List1 Addrbook.Email)
                     Addrbook.Tel
            deriving (Eq,Show,Generic)
newtype Name = Name Str 		deriving (Eq,Show,Generic)
newtype Email = Email Str 		deriving (Eq,Show,Generic)
newtype Tel = Tel Str 		deriving (Eq,Show,Generic)
instance HTypeable Addrbook.Addrbook where
    toHType x = Defined "addrbook" [] []
instance XmlContent Addrbook.Addrbook where
    toContents (Addrbook.Addrbook a) =
        [CElem (Elem (N "addrbook") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["addrbook"]
        ; interior e $ return (Addrbook.Addrbook)
                       `apply` many parseContents
        } `adjustErr` ("in <addrbook>, "++)
instance HTypeable Addrbook.Person where
    toHType x = Defined "person" [] []
instance XmlContent Addrbook.Person where
    toContents (Addrbook.Person a b c) =
        [CElem (Elem (N "person") [] (toContents a ++ toContents b ++
                                      toContents c)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["person"]
        ; interior e $ return (Addrbook.Person) `apply` parseContents
                       `apply` parseContents `apply` parseContents
        } `adjustErr` ("in <person>, "++)
instance HTypeable Addrbook.Name where
    toHType x = Defined "name" [] []
instance XmlContent Addrbook.Name where
    toContents (Addrbook.Name a) =
        [CElem (Elem (N "name") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["name"]
        ; interior e $ return (Addrbook.Name)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <name>, "++)
instance HTypeable Addrbook.Email where
    toHType x = Defined "email" [] []
instance XmlContent Addrbook.Email where
    toContents (Addrbook.Email a) =
        [CElem (Elem (N "email") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["email"]
        ; interior e $ return (Addrbook.Email)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <email>, "++)
instance HTypeable Addrbook.Tel where
    toHType x = Defined "tel" [] []
instance XmlContent Addrbook.Tel where
    toContents (Addrbook.Tel a) =
        [CElem (Elem (N "tel") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["tel"]
        ; interior e $ return (Addrbook.Tel)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <tel>, "++)
instance Typeable Addrbook.Addrbook where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "addrbook" "Addrbook") typeof
instance Typeable Addrbook.Person where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "person" "Person") typeof
instance Typeable Addrbook.Name where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "name" "Name") typeof
instance Typeable Addrbook.Email where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "email" "Email") typeof
instance Typeable Addrbook.Tel where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "tel" "Tel") typeof

typeEnv = Map.insert "addrbook" (DynT (typeof :: Type (Addrbook.Addrbook))) (Map.insert "person" (DynT (typeof :: Type (Addrbook.Person))) (Map.insert "name" (DynT (typeof :: Type (Addrbook.Name))) (Map.insert "email" (DynT (typeof :: Type (Addrbook.Email))) (Map.insert "tel" (DynT (typeof :: Type (Addrbook.Tel))) (Map.empty)))))
