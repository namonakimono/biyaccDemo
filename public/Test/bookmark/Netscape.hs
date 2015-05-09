{-# LANGUAGE DeriveGeneric #-}
module Netscape where

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


data Html = Html Netscape.Head Netscape.Body
          deriving (Eq,Show,Generic)
newtype Head = Head Str 		deriving (Eq,Show,Generic)
data Body = Body Netscape.H1 Netscape.Dl
          deriving (Eq,Show,Generic)
newtype H1 = H1 Str 		deriving (Eq,Show,Generic)
newtype Dl = Dl [(Either Netscape.Dt Netscape.Dd)] 		deriving (Eq,Show,Generic)
newtype Dt = Dt Netscape.A 		deriving (Eq,Show,Generic)
data A = A A_Attrs Str
       deriving (Eq,Show,Generic)
data A_Attrs = A_Attrs
    { aHref :: Str
    } deriving (Eq,Show,Generic)
data Dd = Dd Netscape.H3 Netscape.Dl
        deriving (Eq,Show,Generic)
newtype H3 = H3 Str 		deriving (Eq,Show,Generic)
instance HTypeable Netscape.Html where
    toHType x = Defined "html" [] []
instance XmlContent Netscape.Html where
    toContents (Netscape.Html a b) =
        [CElem (Elem (N "html") [] (toContents a ++ toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["html"]
        ; interior e $ return (Netscape.Html) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <html>, "++)
instance HTypeable Netscape.Head where
    toHType x = Defined "head" [] []
instance XmlContent Netscape.Head where
    toContents (Netscape.Head a) =
        [CElem (Elem (N "head") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["head"]
        ; interior e $ return (Netscape.Head)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <head>, "++)
instance HTypeable Netscape.Body where
    toHType x = Defined "body" [] []
instance XmlContent Netscape.Body where
    toContents (Netscape.Body a b) =
        [CElem (Elem (N "body") [] (toContents a ++ toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["body"]
        ; interior e $ return (Netscape.Body) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <body>, "++)
instance HTypeable Netscape.H1 where
    toHType x = Defined "h1" [] []
instance XmlContent Netscape.H1 where
    toContents (Netscape.H1 a) =
        [CElem (Elem (N "h1") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["h1"]
        ; interior e $ return (Netscape.H1)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <h1>, "++)
instance HTypeable Netscape.Dl where
    toHType x = Defined "dl" [] []
instance XmlContent Netscape.Dl where
    toContents (Netscape.Dl a) =
        [CElem (Elem (N "dl") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["dl"]
        ; interior e $ return (Netscape.Dl) `apply` many parseContents
        } `adjustErr` ("in <dl>, "++)
instance HTypeable Netscape.Dt where
    toHType x = Defined "dt" [] []
instance XmlContent Netscape.Dt where
    toContents (Netscape.Dt a) =
        [CElem (Elem (N "dt") [] (toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["dt"]
        ; interior e $ return (Netscape.Dt) `apply` parseContents
        } `adjustErr` ("in <dt>, "++)
instance HTypeable Netscape.A where
    toHType x = Defined "a" [] []
instance XmlContent Netscape.A where
    toContents (Netscape.A as a) =
        [CElem (Elem (N "a") (toAttrs as) ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["a"]
        ; interior e $ return (Netscape.A (fromAttrs as))
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <a>, "++)
instance XmlAttributes Netscape.A_Attrs where
    fromAttrs as =
        Netscape.A_Attrs
          { Netscape.aHref = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "a" "href" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "href" (Netscape.aHref v)
        ]
instance HTypeable Netscape.Dd where
    toHType x = Defined "dd" [] []
instance XmlContent Netscape.Dd where
    toContents (Netscape.Dd a b) =
        [CElem (Elem (N "dd") [] (toContents a ++ toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["dd"]
        ; interior e $ return (Netscape.Dd) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <dd>, "++)
instance HTypeable Netscape.H3 where
    toHType x = Defined "h3" [] []
instance XmlContent Netscape.H3 where
    toContents (Netscape.H3 a) =
        [CElem (Elem (N "h3") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["h3"]
        ; interior e $ return (Netscape.H3)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <h3>, "++)
instance Typeable Netscape.Html where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "html" "Html") typeof
instance Typeable Netscape.Head where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "head" "Head") typeof
instance Typeable Netscape.Body where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "body" "Body") typeof
instance Typeable Netscape.H1 where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "h1" "H1") typeof
instance Typeable Netscape.Dl where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "dl" "Dl") typeof
instance Typeable Netscape.Dt where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "dt" "Dt") typeof
instance Typeable Netscape.A where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "a" "A") typeof
instance Typeable Netscape.A_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "A_Attrs") (Tag "@href" typeof)
instance Typeable Netscape.Dd where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "dd" "Dd") typeof
instance Typeable Netscape.H3 where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "h3" "H3") typeof

typeEnv = Map.insert "html" (DynT (typeof :: Type (Netscape.Html))) (Map.insert "head" (DynT (typeof :: Type (Netscape.Head))) (Map.insert "body" (DynT (typeof :: Type (Netscape.Body))) (Map.insert "h1" (DynT (typeof :: Type (Netscape.H1))) (Map.insert "dl" (DynT (typeof :: Type (Netscape.Dl))) (Map.insert "dt" (DynT (typeof :: Type (Netscape.Dt))) (Map.insert "a" (DynT (typeof :: Type (Netscape.A))) (Map.insert "dd" (DynT (typeof :: Type (Netscape.Dd))) (Map.insert "h3" (DynT (typeof :: Type (Netscape.H3))) (Map.empty)))))))))
