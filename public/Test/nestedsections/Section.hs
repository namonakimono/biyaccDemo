{-# LANGUAGE DeriveGeneric #-}
module Section where

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


newtype Sections = Sections [Section.Section] 		deriving (Eq,Show,Generic)
data Section = Section Section.Title (Mb Section.Paragraph)
                       [Section.Subsection]
             deriving (Eq,Show,Generic)
newtype Title = Title Str 		deriving (Eq,Show,Generic)
newtype Paragraph = Paragraph Str 		deriving (Eq,Show,Generic)
data Subsection = Subsection Section.Title (Mb Section.Paragraph)
                deriving (Eq,Show,Generic)
instance HTypeable Section.Sections where
    toHType x = Defined "sections" [] []
instance XmlContent Section.Sections where
    toContents (Section.Sections a) =
        [CElem (Elem (N "sections") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["sections"]
        ; interior e $ return (Section.Sections) `apply` many parseContents
        } `adjustErr` ("in <sections>, "++)
instance HTypeable Section.Section where
    toHType x = Defined "section" [] []
instance XmlContent Section.Section where
    toContents (Section.Section a b c) =
        [CElem (Elem (N "section") [] (toContents a ++
                                       maybeMb [] toContents b ++ concatMap toContents c)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["section"]
        ; interior e $ return (Section.Section) `apply` parseContents
                       `apply` optionalMb parseContents `apply` many parseContents
        } `adjustErr` ("in <section>, "++)
instance HTypeable Section.Title where
    toHType x = Defined "title" [] []
instance XmlContent Section.Title where
    toContents (Section.Title a) =
        [CElem (Elem (N "title") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["title"]
        ; interior e $ return (Section.Title)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <title>, "++)
instance HTypeable Section.Paragraph where
    toHType x = Defined "paragraph" [] []
instance XmlContent Section.Paragraph where
    toContents (Section.Paragraph a) =
        [CElem (Elem (N "paragraph") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["paragraph"]
        ; interior e $ return (Section.Paragraph)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <paragraph>, "++)
instance HTypeable Section.Subsection where
    toHType x = Defined "subsection" [] []
instance XmlContent Section.Subsection where
    toContents (Section.Subsection a b) =
        [CElem (Elem (N "subsection") [] (toContents a ++
                                          maybeMb [] toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["subsection"]
        ; interior e $ return (Section.Subsection) `apply` parseContents
                       `apply` optionalMb parseContents
        } `adjustErr` ("in <subsection>, "++)
instance Typeable Section.Sections where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "sections" "Sections") typeof
instance Typeable Section.Section where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "section" "Section") typeof
instance Typeable Section.Title where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "title" "Title") typeof
instance Typeable Section.Paragraph where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "paragraph" "Paragraph") typeof
instance Typeable Section.Subsection where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "subsection" "Subsection") typeof

typeEnv = Map.insert "sections" (DynT (typeof :: Type (Section.Sections))) (Map.insert "section" (DynT (typeof :: Type (Section.Section))) (Map.insert "title" (DynT (typeof :: Type (Section.Title))) (Map.insert "paragraph" (DynT (typeof :: Type (Section.Paragraph))) (Map.insert "subsection" (DynT (typeof :: Type (Section.Subsection))) (Map.empty)))))
