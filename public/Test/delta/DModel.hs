{-# LANGUAGE DeriveGeneric #-}
module DModel where

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


newtype Deltas = Deltas (List1 DModel.Delta) 		deriving (Eq,Show,Generic)
data Delta = Delta
    { deltaTarget :: Str
    } deriving (Eq,Show,Generic)
instance HTypeable DModel.Deltas where
    toHType x = Defined "deltas" [] []
instance XmlContent DModel.Deltas where
    toContents (DModel.Deltas a) =
        [CElem (Elem (N "deltas") [] (toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["deltas"]
        ; interior e $ return (DModel.Deltas) `apply` parseContents
        } `adjustErr` ("in <deltas>, "++)
instance HTypeable DModel.Delta where
    toHType x = Defined "delta" [] []
instance XmlContent DModel.Delta where
    toContents as =
        [CElem (Elem (N "delta") (toAttrs as) []) ()]
    parseContents = do
        { (Elem _ as []) <- element ["delta"]
        ; return (fromAttrs as)
        } `adjustErr` ("in <delta>, "++)
instance XmlAttributes DModel.Delta where
    fromAttrs as =
        DModel.Delta
          { DModel.deltaTarget = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "delta" "target" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "target" (DModel.deltaTarget v)
        ]
instance Typeable DModel.Deltas where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "deltas" "Deltas") typeof
instance Typeable DModel.Delta where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "delta" "Delta") (Tag "@target" typeof)

typeEnv = Map.insert "deltas" (DynT (typeof :: Type (DModel.Deltas))) (Map.insert "delta" (DynT (typeof :: Type (DModel.Delta))) (Map.empty))
