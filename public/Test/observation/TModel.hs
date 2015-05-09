{-# LANGUAGE DeriveGeneric #-}
module TModel where

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


newtype Observations = Observations (List1 TModel.Observation) 		deriving (Eq,Show,Generic)
data Observation = Observation (Mb TModel.Normal)
                               [TModel.Exceptional]
                 deriving (Eq,Show,Generic)
data Normal = Normal
    { normalReturn :: Str
    } deriving (Eq,Show,Generic)
data Exceptional = Exceptional
    { exceptionalName :: Str
    } deriving (Eq,Show,Generic)
instance HTypeable TModel.Observations where
    toHType x = Defined "observations" [] []
instance XmlContent TModel.Observations where
    toContents (TModel.Observations a) =
        [CElem (Elem (N "observations") [] (toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["observations"]
        ; interior e $ return (TModel.Observations) `apply` parseContents
        } `adjustErr` ("in <observations>, "++)
instance HTypeable TModel.Observation where
    toHType x = Defined "observation" [] []
instance XmlContent TModel.Observation where
    toContents (TModel.Observation a b) =
        [CElem (Elem (N "observation") [] (maybeMb [] toContents a ++
                                           concatMap toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["observation"]
        ; interior e $ return (TModel.Observation)
                       `apply` optionalMb parseContents `apply` many parseContents
        } `adjustErr` ("in <observation>, "++)
instance HTypeable TModel.Normal where
    toHType x = Defined "normal" [] []
instance XmlContent TModel.Normal where
    toContents as =
        [CElem (Elem (N "normal") (toAttrs as) []) ()]
    parseContents = do
        { (Elem _ as []) <- element ["normal"]
        ; return (fromAttrs as)
        } `adjustErr` ("in <normal>, "++)
instance XmlAttributes TModel.Normal where
    fromAttrs as =
        TModel.Normal
          { TModel.normalReturn = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "normal" "return" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "return" (TModel.normalReturn v)
        ]
instance HTypeable TModel.Exceptional where
    toHType x = Defined "exceptional" [] []
instance XmlContent TModel.Exceptional where
    toContents as =
        [CElem (Elem (N "exceptional") (toAttrs as) []) ()]
    parseContents = do
        { (Elem _ as []) <- element ["exceptional"]
        ; return (fromAttrs as)
        } `adjustErr` ("in <exceptional>, "++)
instance XmlAttributes TModel.Exceptional where
    fromAttrs as =
        TModel.Exceptional
          { TModel.exceptionalName = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "exceptional" "name" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "name" (TModel.exceptionalName v)
        ]
instance Typeable TModel.Observations where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "observations" "Observations") typeof
instance Typeable TModel.Observation where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "observation" "Observation") typeof
instance Typeable TModel.Normal where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "normal" "Normal") (Tag "@return" typeof)
instance Typeable TModel.Exceptional where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "exceptional" "Exceptional") (Tag "@name" typeof)

typeEnv = Map.insert "observations" (DynT (typeof :: Type (TModel.Observations))) (Map.insert "observation" (DynT (typeof :: Type (TModel.Observation))) (Map.insert "normal" (DynT (typeof :: Type (TModel.Normal))) (Map.insert "exceptional" (DynT (typeof :: Type (TModel.Exceptional))) (Map.empty))))
