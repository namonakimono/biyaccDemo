{-# LANGUAGE DeriveGeneric #-}
module Model where

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


newtype Initials = Initials (List1 Model.Initial) 		deriving (Eq,Show,Generic)
data Initial = Initial
    { initialName :: Str
    } deriving (Eq,Show,Generic)
instance HTypeable Model.Initials where
    toHType x = Defined "initials" [] []
instance XmlContent Model.Initials where
    toContents (Model.Initials a) =
        [CElem (Elem (N "initials") [] (toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["initials"]
        ; interior e $ return (Model.Initials) `apply` parseContents
        } `adjustErr` ("in <initials>, "++)
instance HTypeable Model.Initial where
    toHType x = Defined "initial" [] []
instance XmlContent Model.Initial where
    toContents as =
        [CElem (Elem (N "initial") (toAttrs as) []) ()]
    parseContents = do
        { (Elem _ as []) <- element ["initial"]
        ; return (fromAttrs as)
        } `adjustErr` ("in <initial>, "++)
instance XmlAttributes Model.Initial where
    fromAttrs as =
        Model.Initial
          { Model.initialName = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "initial" "name" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "name" (Model.initialName v)
        ]
instance Typeable Model.Initials where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "initials" "Initials") typeof
instance Typeable Model.Initial where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "initial" "Initial") (Tag "@name" typeof)

typeEnv = Map.insert "initials" (DynT (typeof :: Type (Model.Initials))) (Map.insert "initial" (DynT (typeof :: Type (Model.Initial))) (Map.empty))
