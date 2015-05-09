{-# LANGUAGE DeriveGeneric #-}
module Sec where

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


newtype Secs = Secs [Sec.Sec] 		deriving (Eq,Show,Generic)
data Sec = Sec Sec_Attrs [Sec.Subsec]
         deriving (Eq,Show,Generic)
data Sec_Attrs = Sec_Attrs
    { secTitle :: Str
    } deriving (Eq,Show,Generic)
data Subsec = Subsec Subsec_Attrs Sec.EMPTY
            deriving (Eq,Show,Generic)
data Subsec_Attrs = Subsec_Attrs
    { subsecTitle :: Str
    } deriving (Eq,Show,Generic)
instance HTypeable Sec.Secs where
    toHType x = Defined "secs" [] []
instance XmlContent Sec.Secs where
    toContents (Sec.Secs a) =
        [CElem (Elem (N "secs") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["secs"]
        ; interior e $ return (Sec.Secs) `apply` many parseContents
        } `adjustErr` ("in <secs>, "++)
instance HTypeable Sec.Sec where
    toHType x = Defined "sec" [] []
instance XmlContent Sec.Sec where
    toContents (Sec.Sec as a) =
        [CElem (Elem (N "sec") (toAttrs as) (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["sec"]
        ; interior e $ return (Sec.Sec (fromAttrs as))
                       `apply` many parseContents
        } `adjustErr` ("in <sec>, "++)
instance XmlAttributes Sec.Sec_Attrs where
    fromAttrs as =
        Sec.Sec_Attrs
          { Sec.secTitle = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "sec" "title" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "title" (Sec.secTitle v)
        ]
instance HTypeable Sec.Subsec where
    toHType x = Defined "subsec" [] []
instance XmlContent Sec.Subsec where
    toContents (Sec.Subsec as a) =
        [CElem (Elem (N "subsec") (toAttrs as) (toContents a)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["subsec"]
        ; interior e $ return (Sec.Subsec (fromAttrs as))
                       `apply` parseContents
        } `adjustErr` ("in <subsec>, "++)
instance XmlAttributes Sec.Subsec_Attrs where
    fromAttrs as =
        Sec.Subsec_Attrs
          { Sec.subsecTitle = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "subsec" "title" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "title" (Sec.subsecTitle v)
        ]
instance Typeable Sec.Secs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "secs" "Secs") typeof
instance Typeable Sec.Sec where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "sec" "Sec") typeof
instance Typeable Sec.Sec_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "Sec_Attrs") (Tag "@title" typeof)
instance Typeable Sec.Subsec where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "subsec" "Subsec") typeof
instance Typeable Sec.Subsec_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "Subsec_Attrs") (Tag "@title" typeof)

typeEnv = Map.insert "secs" (DynT (typeof :: Type (Sec.Secs))) (Map.insert "sec" (DynT (typeof :: Type (Sec.Sec))) (Map.insert "subsec" (DynT (typeof :: Type (Sec.Subsec))) (Map.empty)))
