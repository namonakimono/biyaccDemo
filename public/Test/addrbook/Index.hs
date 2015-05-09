{-# LANGUAGE DeriveGeneric #-}
module Index where

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


data Addrbook = Addrbook Index.Index [Index.Person]
              deriving (Eq,Show,Generic)
newtype Index = Index [Index.Name] 		deriving (Eq,Show,Generic)
data Person = Person Index.Name Index.Email
            deriving (Eq,Show,Generic)
newtype Name = Name Str 		deriving (Eq,Show,Generic)
newtype Email = Email Str 		deriving (Eq,Show,Generic)
newtype Tel = Tel Str 		deriving (Eq,Show,Generic)
instance HTypeable Index.Addrbook where
    toHType x = Defined "addrbook" [] []
instance XmlContent Index.Addrbook where
    toContents (Index.Addrbook a b) =
        [CElem (Elem (N "addrbook") [] (toContents a ++
                                        concatMap toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["addrbook"]
        ; interior e $ return (Index.Addrbook) `apply` parseContents
                       `apply` many parseContents
        } `adjustErr` ("in <addrbook>, "++)
instance HTypeable Index.Index where
    toHType x = Defined "index" [] []
instance XmlContent Index.Index where
    toContents (Index.Index a) =
        [CElem (Elem (N "index") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["index"]
        ; interior e $ return (Index.Index) `apply` many parseContents
        } `adjustErr` ("in <index>, "++)
instance HTypeable Index.Person where
    toHType x = Defined "person" [] []
instance XmlContent Index.Person where
    toContents (Index.Person a b) =
        [CElem (Elem (N "person") [] (toContents a ++ toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["person"]
        ; interior e $ return (Index.Person) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <person>, "++)
instance HTypeable Index.Name where
    toHType x = Defined "name" [] []
instance XmlContent Index.Name where
    toContents (Index.Name a) =
        [CElem (Elem (N "name") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["name"]
        ; interior e $ return (Index.Name)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <name>, "++)
instance HTypeable Index.Email where
    toHType x = Defined "email" [] []
instance XmlContent Index.Email where
    toContents (Index.Email a) =
        [CElem (Elem (N "email") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["email"]
        ; interior e $ return (Index.Email)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <email>, "++)
instance HTypeable Index.Tel where
    toHType x = Defined "tel" [] []
instance XmlContent Index.Tel where
    toContents (Index.Tel a) =
        [CElem (Elem (N "tel") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["tel"]
        ; interior e $ return (Index.Tel)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <tel>, "++)
instance Typeable Index.Addrbook where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "addrbook" "Addrbook") typeof
instance Typeable Index.Index where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "index" "Index") typeof
instance Typeable Index.Person where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "person" "Person") typeof
instance Typeable Index.Name where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "name" "Name") typeof
instance Typeable Index.Email where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "email" "Email") typeof
instance Typeable Index.Tel where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "tel" "Tel") typeof

typeEnv = Map.insert "addrbook" (DynT (typeof :: Type (Index.Addrbook))) (Map.insert "index" (DynT (typeof :: Type (Index.Index))) (Map.insert "person" (DynT (typeof :: Type (Index.Person))) (Map.insert "name" (DynT (typeof :: Type (Index.Name))) (Map.insert "email" (DynT (typeof :: Type (Index.Email))) (Map.insert "tel" (DynT (typeof :: Type (Index.Tel))) (Map.empty))))))
