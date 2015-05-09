{-# LANGUAGE DeriveGeneric #-}
module People where

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


newtype People = People [People.Person] 		deriving (Eq,Show,Generic)
data Person = Person People.Name People.City
            deriving (Eq,Show,Generic)
newtype Name = Name Str 		deriving (Eq,Show,Generic)
newtype City = City Str 		deriving (Eq,Show,Generic)
instance HTypeable People.People where
    toHType x = Defined "people" [] []
instance XmlContent People.People where
    toContents (People.People a) =
        [CElem (Elem (N "people") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["people"]
        ; interior e $ return (People.People) `apply` many parseContents
        } `adjustErr` ("in <people>, "++)
instance HTypeable People.Person where
    toHType x = Defined "person" [] []
instance XmlContent People.Person where
    toContents (People.Person a b) =
        [CElem (Elem (N "person") [] (toContents a ++ toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["person"]
        ; interior e $ return (People.Person) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <person>, "++)
instance HTypeable People.Name where
    toHType x = Defined "name" [] []
instance XmlContent People.Name where
    toContents (People.Name a) =
        [CElem (Elem (N "name") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["name"]
        ; interior e $ return (People.Name)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <name>, "++)
instance HTypeable People.City where
    toHType x = Defined "city" [] []
instance XmlContent People.City where
    toContents (People.City a) =
        [CElem (Elem (N "city") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["city"]
        ; interior e $ return (People.City)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <city>, "++)
instance Typeable People.People where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "people" "People") typeof
instance Typeable People.Person where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "person" "Person") typeof
instance Typeable People.Name where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "name" "Name") typeof
instance Typeable People.City where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "city" "City") typeof

typeEnv = Map.insert "people" (DynT (typeof :: Type (People.People))) (Map.insert "person" (DynT (typeof :: Type (People.Person))) (Map.insert "name" (DynT (typeof :: Type (People.Name))) (Map.insert "city" (DynT (typeof :: Type (People.City))) (Map.empty))))
