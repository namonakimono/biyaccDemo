{-# LANGUAGE DeriveGeneric #-}
module Code where

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


data Mainclass = Mainclass Mainclass_Attrs Code.Interface
                           Code.Constructor (List1 (Code.Field)) (List1 (Code.Class))
                           [Code.Method]
               deriving (Eq,Show,Generic)
data Mainclass_Attrs = Mainclass_Attrs
    { mainclassName :: Str
    , mainclassPrivate :: (Mb Code.Mainclass_private)
    , mainclassPublic :: (Mb Code.Mainclass_public)
    } deriving (Eq,Show,Generic)
data Mainclass_public = Mainclass_public_true  | 
                        Mainclass_public_false
                      deriving (Eq,Show,Generic)
data Mainclass_private = Mainclass_private_true  | 
                         Mainclass_private_false
                       deriving (Eq,Show,Generic)
data Field = Field Field_Attrs (Mb Code.Init)
           deriving (Eq,Show,Generic)
data Field_Attrs = Field_Attrs
    { fieldFinal :: Code.Field_final
    , fieldName :: Str
    , fieldPrivate :: (Mb Code.Field_private)
    , fieldPublic :: (Mb Code.Field_public)
    , fieldType :: (Mb Str)
    } deriving (Eq,Show,Generic)
data Field_final = Field_final_true  |  Field_final_false
                 deriving (Eq,Show,Generic)
data Field_public = Field_public_true  |  Field_public_false
                  deriving (Eq,Show,Generic)
data Field_private = Field_private_true  |  Field_private_false
                   deriving (Eq,Show,Generic)
newtype Init = Init Str 		deriving (Eq,Show,Generic)
data Interface = Interface Interface_Attrs (List1 Code.Methoddecl)
               deriving (Eq,Show,Generic)
data Interface_Attrs = Interface_Attrs
    { interfaceName :: Str
    , interfacePrivate :: (Mb Code.Interface_private)
    , interfacePublic :: (Mb Code.Interface_public)
    } deriving (Eq,Show,Generic)
data Interface_public = Interface_public_true  | 
                        Interface_public_false
                      deriving (Eq,Show,Generic)
data Interface_private = Interface_private_true  | 
                         Interface_private_false
                       deriving (Eq,Show,Generic)
data Methoddecl = Methoddecl Methoddecl_Attrs [Code.Param]
                deriving (Eq,Show,Generic)
data Methoddecl_Attrs = Methoddecl_Attrs
    { methoddeclName :: Str
    , methoddeclType :: Str
    } deriving (Eq,Show,Generic)
data Param = Param
    { paramFinal :: (Mb Code.Param_final)
    , paramName :: Str
    , paramType :: Str
    } deriving (Eq,Show,Generic)
data Param_final = Param_final_true  |  Param_final_false
                 deriving (Eq,Show,Generic)
data Constructor = Constructor [Code.Param] Code.Code
                 deriving (Eq,Show,Generic)
data Class = Class Class_Attrs [Code.Field] (List1 Code.Method)
           deriving (Eq,Show,Generic)
data Class_Attrs = Class_Attrs
    { classImplements :: Str
    , className :: Str
    , classPrivate :: (Mb Code.Class_private)
    , classPublic :: Code.Class_public
    } deriving (Eq,Show,Generic)
data Class_public = Class_public_true  |  Class_public_false
                  deriving (Eq,Show,Generic)
data Class_private = Class_private_true  |  Class_private_false
                   deriving (Eq,Show,Generic)
data Method = Method Method_Attrs [Code.Param] Code.Code
            deriving (Eq,Show,Generic)
data Method_Attrs = Method_Attrs
    { methodName :: Str
    , methodType :: Str
    } deriving (Eq,Show,Generic)
newtype Code = Code [(Either Code.Statement (Either Code.If (Either Code.Throw (Either Code.Return (Either Code.Assignment Code.Declaration)))))] 		deriving (Eq,Show,Generic)
newtype Statement = Statement Str 		deriving (Eq,Show,Generic)
data If = If Code.Condition Code.Code (Mb Code.Else)
        deriving (Eq,Show,Generic)
newtype Condition = Condition Str 		deriving (Eq,Show,Generic)
newtype Else = Else Code.Code 		deriving (Eq,Show,Generic)
newtype Throw = Throw Str 		deriving (Eq,Show,Generic)
newtype Return = Return Str 		deriving (Eq,Show,Generic)
data Assignment = Assignment Code.Left Code.Right
                deriving (Eq,Show,Generic)
data Declaration = Declaration Declaration_Attrs Code.Left
                               Code.Right
                 deriving (Eq,Show,Generic)
data Declaration_Attrs = Declaration_Attrs
    { declarationType :: Str
    } deriving (Eq,Show,Generic)
newtype Left = Left Str 		deriving (Eq,Show,Generic)
newtype Right = Right Str 		deriving (Eq,Show,Generic)
instance HTypeable Code.Mainclass where
    toHType x = Defined "mainclass" [] []
instance XmlContent Code.Mainclass where
    toContents (Code.Mainclass as a b c d e) =
        [CElem (Elem (N "mainclass") (toAttrs as) (toContents a ++
                                                   toContents b ++ toContents c ++ toContents d ++
                                                   concatMap toContents e)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["mainclass"]
        ; interior e $ return (Code.Mainclass (fromAttrs as))
                       `apply` parseContents `apply` parseContents `apply` parseContents
                       `apply` parseContents `apply` many parseContents
        } `adjustErr` ("in <mainclass>, "++)
instance XmlAttributes Code.Mainclass_Attrs where
    fromAttrs as =
        Code.Mainclass_Attrs
          { Code.mainclassName = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "mainclass" "name" as
          , Code.mainclassPrivate = possibleMbA fromAttrToTyp "private" as
          , Code.mainclassPublic = possibleMbA fromAttrToTyp "public" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "name" (Code.mainclassName v)
        , mbToAttr toAttrFrTyp "private" (Code.mainclassPrivate v)
        , mbToAttr toAttrFrTyp "public" (Code.mainclassPublic v)
        ]
instance XmlAttrType Code.Mainclass_public where
    fromAttrToTyp n (N n',v)
        | n==n'     = translate (attr2str v)
        | otherwise = Nothing
      where translate "true" = Just Code.Mainclass_public_true
            translate "false" = Just Code.Mainclass_public_false
            translate _ = Nothing
    toAttrFrTyp n Code.Mainclass_public_true = Just (N n, str2attr "true")
    toAttrFrTyp n Code.Mainclass_public_false = Just (N n, str2attr "false")
instance XmlAttrType Code.Mainclass_private where
    fromAttrToTyp n (N n',v)
        | n==n'     = translate (attr2str v)
        | otherwise = Nothing
      where translate "true" = Just Code.Mainclass_private_true
            translate "false" = Just Code.Mainclass_private_false
            translate _ = Nothing
    toAttrFrTyp n Code.Mainclass_private_true = Just (N n, str2attr "true")
    toAttrFrTyp n Code.Mainclass_private_false = Just (N n, str2attr "false")
instance HTypeable Code.Field where
    toHType x = Defined "field" [] []
instance XmlContent Code.Field where
    toContents (Code.Field as a) =
        [CElem (Elem (N "field") (toAttrs as) (maybeMb [] toContents a)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["field"]
        ; interior e $ return (Code.Field (fromAttrs as))
                       `apply` optionalMb parseContents
        } `adjustErr` ("in <field>, "++)
instance XmlAttributes Code.Field_Attrs where
    fromAttrs as =
        Code.Field_Attrs
          { Code.fieldFinal = definiteA fromAttrToTyp "field" "final" as
          , Code.fieldName = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "field" "name" as
          , Code.fieldPrivate = possibleMbA fromAttrToTyp "private" as
          , Code.fieldPublic = possibleMbA fromAttrToTyp "public" as
          , Code.fieldType = possibleMbA (\a b -> fmap Str $ fromAttrToStr a b) "type" as
          }
    toAttrs v = catMaybes 
        [ toAttrFrTyp "final" (Code.fieldFinal v)
        , (\s x -> toAttrFrStr s (unStr x)) "name" (Code.fieldName v)
        , mbToAttr toAttrFrTyp "private" (Code.fieldPrivate v)
        , mbToAttr toAttrFrTyp "public" (Code.fieldPublic v)
        , mbToAttr (\s x -> toAttrFrStr s (unStr x)) "type" (Code.fieldType v)
        ]
instance XmlAttrType Code.Field_final where
    fromAttrToTyp n (N n',v)
        | n==n'     = translate (attr2str v)
        | otherwise = Nothing
      where translate "true" = Just Code.Field_final_true
            translate "false" = Just Code.Field_final_false
            translate _ = Nothing
    toAttrFrTyp n Code.Field_final_true = Just (N n, str2attr "true")
    toAttrFrTyp n Code.Field_final_false = Just (N n, str2attr "false")
instance XmlAttrType Code.Field_public where
    fromAttrToTyp n (N n',v)
        | n==n'     = translate (attr2str v)
        | otherwise = Nothing
      where translate "true" = Just Code.Field_public_true
            translate "false" = Just Code.Field_public_false
            translate _ = Nothing
    toAttrFrTyp n Code.Field_public_true = Just (N n, str2attr "true")
    toAttrFrTyp n Code.Field_public_false = Just (N n, str2attr "false")
instance XmlAttrType Code.Field_private where
    fromAttrToTyp n (N n',v)
        | n==n'     = translate (attr2str v)
        | otherwise = Nothing
      where translate "true" = Just Code.Field_private_true
            translate "false" = Just Code.Field_private_false
            translate _ = Nothing
    toAttrFrTyp n Code.Field_private_true = Just (N n, str2attr "true")
    toAttrFrTyp n Code.Field_private_false = Just (N n, str2attr "false")
instance HTypeable Code.Init where
    toHType x = Defined "init" [] []
instance XmlContent Code.Init where
    toContents (Code.Init a) =
        [CElem (Elem (N "init") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["init"]
        ; interior e $ return (Code.Init)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <init>, "++)
instance HTypeable Code.Interface where
    toHType x = Defined "interface" [] []
instance XmlContent Code.Interface where
    toContents (Code.Interface as a) =
        [CElem (Elem (N "interface") (toAttrs as) (toContents a)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["interface"]
        ; interior e $ return (Code.Interface (fromAttrs as))
                       `apply` parseContents
        } `adjustErr` ("in <interface>, "++)
instance XmlAttributes Code.Interface_Attrs where
    fromAttrs as =
        Code.Interface_Attrs
          { Code.interfaceName = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "interface" "name" as
          , Code.interfacePrivate = possibleMbA fromAttrToTyp "private" as
          , Code.interfacePublic = possibleMbA fromAttrToTyp "public" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "name" (Code.interfaceName v)
        , mbToAttr toAttrFrTyp "private" (Code.interfacePrivate v)
        , mbToAttr toAttrFrTyp "public" (Code.interfacePublic v)
        ]
instance XmlAttrType Code.Interface_public where
    fromAttrToTyp n (N n',v)
        | n==n'     = translate (attr2str v)
        | otherwise = Nothing
      where translate "true" = Just Code.Interface_public_true
            translate "false" = Just Code.Interface_public_false
            translate _ = Nothing
    toAttrFrTyp n Code.Interface_public_true = Just (N n, str2attr "true")
    toAttrFrTyp n Code.Interface_public_false = Just (N n, str2attr "false")
instance XmlAttrType Code.Interface_private where
    fromAttrToTyp n (N n',v)
        | n==n'     = translate (attr2str v)
        | otherwise = Nothing
      where translate "true" = Just Code.Interface_private_true
            translate "false" = Just Code.Interface_private_false
            translate _ = Nothing
    toAttrFrTyp n Code.Interface_private_true = Just (N n, str2attr "true")
    toAttrFrTyp n Code.Interface_private_false = Just (N n, str2attr "false")
instance HTypeable Code.Methoddecl where
    toHType x = Defined "methoddecl" [] []
instance XmlContent Code.Methoddecl where
    toContents (Code.Methoddecl as a) =
        [CElem (Elem (N "methoddecl") (toAttrs as) (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["methoddecl"]
        ; interior e $ return (Code.Methoddecl (fromAttrs as))
                       `apply` many parseContents
        } `adjustErr` ("in <methoddecl>, "++)
instance XmlAttributes Code.Methoddecl_Attrs where
    fromAttrs as =
        Code.Methoddecl_Attrs
          { Code.methoddeclName = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "methoddecl" "name" as
          , Code.methoddeclType = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "methoddecl" "type" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "name" (Code.methoddeclName v)
        , (\s x -> toAttrFrStr s (unStr x)) "type" (Code.methoddeclType v)
        ]
instance HTypeable Code.Param where
    toHType x = Defined "param" [] []
instance XmlContent Code.Param where
    toContents as =
        [CElem (Elem (N "param") (toAttrs as) []) ()]
    parseContents = do
        { (Elem _ as []) <- element ["param"]
        ; return (fromAttrs as)
        } `adjustErr` ("in <param>, "++)
instance XmlAttributes Code.Param where
    fromAttrs as =
        Code.Param
          { Code.paramFinal = possibleMbA fromAttrToTyp "final" as
          , Code.paramName = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "param" "name" as
          , Code.paramType = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "param" "type" as
          }
    toAttrs v = catMaybes 
        [ mbToAttr toAttrFrTyp "final" (Code.paramFinal v)
        , (\s x -> toAttrFrStr s (unStr x)) "name" (Code.paramName v)
        , (\s x -> toAttrFrStr s (unStr x)) "type" (Code.paramType v)
        ]
instance XmlAttrType Code.Param_final where
    fromAttrToTyp n (N n',v)
        | n==n'     = translate (attr2str v)
        | otherwise = Nothing
      where translate "true" = Just Code.Param_final_true
            translate "false" = Just Code.Param_final_false
            translate _ = Nothing
    toAttrFrTyp n Code.Param_final_true = Just (N n, str2attr "true")
    toAttrFrTyp n Code.Param_final_false = Just (N n, str2attr "false")
instance HTypeable Code.Constructor where
    toHType x = Defined "constructor" [] []
instance XmlContent Code.Constructor where
    toContents (Code.Constructor a b) =
        [CElem (Elem (N "constructor") [] (concatMap toContents a ++
                                           toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["constructor"]
        ; interior e $ return (Code.Constructor) `apply` many parseContents
                       `apply` parseContents
        } `adjustErr` ("in <constructor>, "++)
instance HTypeable Code.Class where
    toHType x = Defined "class" [] []
instance XmlContent Code.Class where
    toContents (Code.Class as a b) =
        [CElem (Elem (N "class") (toAttrs as) (concatMap toContents a ++
                                               toContents b)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["class"]
        ; interior e $ return (Code.Class (fromAttrs as))
                       `apply` many parseContents `apply` parseContents
        } `adjustErr` ("in <class>, "++)
instance XmlAttributes Code.Class_Attrs where
    fromAttrs as =
        Code.Class_Attrs
          { Code.classImplements = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "class" "implements" as
          , Code.className = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "class" "name" as
          , Code.classPrivate = possibleMbA fromAttrToTyp "private" as
          , Code.classPublic = definiteA fromAttrToTyp "class" "public" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "implements" (Code.classImplements v)
        , (\s x -> toAttrFrStr s (unStr x)) "name" (Code.className v)
        , mbToAttr toAttrFrTyp "private" (Code.classPrivate v)
        , toAttrFrTyp "public" (Code.classPublic v)
        ]
instance XmlAttrType Code.Class_public where
    fromAttrToTyp n (N n',v)
        | n==n'     = translate (attr2str v)
        | otherwise = Nothing
      where translate "true" = Just Code.Class_public_true
            translate "false" = Just Code.Class_public_false
            translate _ = Nothing
    toAttrFrTyp n Code.Class_public_true = Just (N n, str2attr "true")
    toAttrFrTyp n Code.Class_public_false = Just (N n, str2attr "false")
instance XmlAttrType Code.Class_private where
    fromAttrToTyp n (N n',v)
        | n==n'     = translate (attr2str v)
        | otherwise = Nothing
      where translate "true" = Just Code.Class_private_true
            translate "false" = Just Code.Class_private_false
            translate _ = Nothing
    toAttrFrTyp n Code.Class_private_true = Just (N n, str2attr "true")
    toAttrFrTyp n Code.Class_private_false = Just (N n, str2attr "false")
instance HTypeable Code.Method where
    toHType x = Defined "method" [] []
instance XmlContent Code.Method where
    toContents (Code.Method as a b) =
        [CElem (Elem (N "method") (toAttrs as) (concatMap toContents a ++
                                                toContents b)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["method"]
        ; interior e $ return (Code.Method (fromAttrs as))
                       `apply` many parseContents `apply` parseContents
        } `adjustErr` ("in <method>, "++)
instance XmlAttributes Code.Method_Attrs where
    fromAttrs as =
        Code.Method_Attrs
          { Code.methodName = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "method" "name" as
          , Code.methodType = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "method" "type" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "name" (Code.methodName v)
        , (\s x -> toAttrFrStr s (unStr x)) "type" (Code.methodType v)
        ]
instance HTypeable Code.Code where
    toHType x = Defined "code" [] []
instance XmlContent Code.Code where
    toContents (Code.Code a) =
        [CElem (Elem (N "code") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["code"]
        ; interior e $ return (Code.Code) `apply` many parseContents
        } `adjustErr` ("in <code>, "++)
instance HTypeable Code.Statement where
    toHType x = Defined "statement" [] []
instance XmlContent Code.Statement where
    toContents (Code.Statement a) =
        [CElem (Elem (N "statement") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["statement"]
        ; interior e $ return (Code.Statement)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <statement>, "++)
instance HTypeable Code.If where
    toHType x = Defined "if" [] []
instance XmlContent Code.If where
    toContents (Code.If a b c) =
        [CElem (Elem (N "if") [] (toContents a ++ toContents b ++
                                  maybeMb [] toContents c)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["if"]
        ; interior e $ return (Code.If) `apply` parseContents
                       `apply` parseContents `apply` optionalMb parseContents
        } `adjustErr` ("in <if>, "++)
instance HTypeable Code.Condition where
    toHType x = Defined "condition" [] []
instance XmlContent Code.Condition where
    toContents (Code.Condition a) =
        [CElem (Elem (N "condition") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["condition"]
        ; interior e $ return (Code.Condition)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <condition>, "++)
instance HTypeable Code.Else where
    toHType x = Defined "else" [] []
instance XmlContent Code.Else where
    toContents (Code.Else a) =
        [CElem (Elem (N "else") [] (toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["else"]
        ; interior e $ return (Code.Else) `apply` parseContents
        } `adjustErr` ("in <else>, "++)
instance HTypeable Code.Throw where
    toHType x = Defined "throw" [] []
instance XmlContent Code.Throw where
    toContents (Code.Throw a) =
        [CElem (Elem (N "throw") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["throw"]
        ; interior e $ return (Code.Throw)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <throw>, "++)
instance HTypeable Code.Return where
    toHType x = Defined "return" [] []
instance XmlContent Code.Return where
    toContents (Code.Return a) =
        [CElem (Elem (N "return") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["return"]
        ; interior e $ return (Code.Return)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <return>, "++)
instance HTypeable Code.Assignment where
    toHType x = Defined "assignment" [] []
instance XmlContent Code.Assignment where
    toContents (Code.Assignment a b) =
        [CElem (Elem (N "assignment") [] (toContents a ++
                                          toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["assignment"]
        ; interior e $ return (Code.Assignment) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <assignment>, "++)
instance HTypeable Code.Declaration where
    toHType x = Defined "declaration" [] []
instance XmlContent Code.Declaration where
    toContents (Code.Declaration as a b) =
        [CElem (Elem (N "declaration") (toAttrs as) (toContents a ++
                                                     toContents b)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["declaration"]
        ; interior e $ return (Code.Declaration (fromAttrs as))
                       `apply` parseContents `apply` parseContents
        } `adjustErr` ("in <declaration>, "++)
instance XmlAttributes Code.Declaration_Attrs where
    fromAttrs as =
        Code.Declaration_Attrs
          { Code.declarationType = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "declaration" "type" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "type" (Code.declarationType v)
        ]
instance HTypeable Code.Left where
    toHType x = Defined "left" [] []
instance XmlContent Code.Left where
    toContents (Code.Left a) =
        [CElem (Elem (N "left") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["left"]
        ; interior e $ return (Code.Left)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <left>, "++)
instance HTypeable Code.Right where
    toHType x = Defined "right" [] []
instance XmlContent Code.Right where
    toContents (Code.Right a) =
        [CElem (Elem (N "right") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["right"]
        ; interior e $ return (Code.Right)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <right>, "++)
instance Typeable Code.Mainclass where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "mainclass" "Mainclass") typeof
instance Typeable Code.Mainclass_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "Mainclass_Attrs") (Prod (Tag "@name" typeof) (Prod (Either One (Tag "@private" typeof)) (Either One (Tag "@public" typeof))))
instance Typeable Code.Mainclass_public where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "public" "Mainclass_public") typeof
instance Typeable Code.Mainclass_private where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "private" "Mainclass_private") typeof
instance Typeable Code.Field where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "field" "Field") typeof
instance Typeable Code.Field_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "Field_Attrs") (Prod (Prod (Tag "@final" typeof) (Tag "@name" typeof)) (Prod (Either One (Tag "@private" typeof)) (Prod (Either One (Tag "@public" typeof)) (Either One (Tag "@type" typeof)))))
instance Typeable Code.Field_final where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "final" "Field_final") typeof
instance Typeable Code.Field_public where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "public" "Field_public") typeof
instance Typeable Code.Field_private where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "private" "Field_private") typeof
instance Typeable Code.Init where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "init" "Init") typeof
instance Typeable Code.Interface where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "interface" "Interface") typeof
instance Typeable Code.Interface_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "Interface_Attrs") (Prod (Tag "@name" typeof) (Prod (Either One (Tag "@private" typeof)) (Either One (Tag "@public" typeof))))
instance Typeable Code.Interface_public where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "public" "Interface_public") typeof
instance Typeable Code.Interface_private where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "private" "Interface_private") typeof
instance Typeable Code.Methoddecl where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "methoddecl" "Methoddecl") typeof
instance Typeable Code.Methoddecl_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "Methoddecl_Attrs") (Prod (Tag "@name" typeof) (Tag "@type" typeof))
instance Typeable Code.Param where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "param" "Param") (Prod (Either One (Tag "@final" typeof)) (Prod (Tag "@name" typeof) (Tag "@type" typeof)))
instance Typeable Code.Param_final where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "final" "Param_final") typeof
instance Typeable Code.Constructor where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "constructor" "Constructor") typeof
instance Typeable Code.Class where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "class" "Class") typeof
instance Typeable Code.Class_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "Class_Attrs") (Prod (Prod (Tag "@implements" typeof) (Tag "@name" typeof)) (Prod (Either One (Tag "@private" typeof)) (Tag "@public" typeof)))
instance Typeable Code.Class_public where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "public" "Class_public") typeof
instance Typeable Code.Class_private where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "private" "Class_private") typeof
instance Typeable Code.Method where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "method" "Method") typeof
instance Typeable Code.Method_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "Method_Attrs") (Prod (Tag "@name" typeof) (Tag "@type" typeof))
instance Typeable Code.Code where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "code" "Code") typeof
instance Typeable Code.Statement where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "statement" "Statement") typeof
instance Typeable Code.If where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "if" "If") typeof
instance Typeable Code.Condition where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "condition" "Condition") typeof
instance Typeable Code.Else where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "else" "Else") typeof
instance Typeable Code.Throw where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "throw" "Throw") typeof
instance Typeable Code.Return where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "return" "Return") typeof
instance Typeable Code.Assignment where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "assignment" "Assignment") typeof
instance Typeable Code.Declaration where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "declaration" "Declaration") typeof
instance Typeable Code.Declaration_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "Declaration_Attrs") (Tag "@type" typeof)
instance Typeable Code.Left where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "left" "Left") typeof
instance Typeable Code.Right where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "right" "Right") typeof

typeEnv = Map.insert "mainclass" (DynT (typeof :: Type (Code.Mainclass))) (Map.insert "public" (DynT (typeof :: Type (Code.Mainclass_public))) (Map.insert "private" (DynT (typeof :: Type (Code.Mainclass_private))) (Map.insert "field" (DynT (typeof :: Type (Code.Field))) (Map.insert "final" (DynT (typeof :: Type (Code.Field_final))) (Map.insert "public" (DynT (typeof :: Type (Code.Field_public))) (Map.insert "private" (DynT (typeof :: Type (Code.Field_private))) (Map.insert "init" (DynT (typeof :: Type (Code.Init))) (Map.insert "interface" (DynT (typeof :: Type (Code.Interface))) (Map.insert "public" (DynT (typeof :: Type (Code.Interface_public))) (Map.insert "private" (DynT (typeof :: Type (Code.Interface_private))) (Map.insert "methoddecl" (DynT (typeof :: Type (Code.Methoddecl))) (Map.insert "param" (DynT (typeof :: Type (Code.Param))) (Map.insert "final" (DynT (typeof :: Type (Code.Param_final))) (Map.insert "constructor" (DynT (typeof :: Type (Code.Constructor))) (Map.insert "class" (DynT (typeof :: Type (Code.Class))) (Map.insert "public" (DynT (typeof :: Type (Code.Class_public))) (Map.insert "private" (DynT (typeof :: Type (Code.Class_private))) (Map.insert "method" (DynT (typeof :: Type (Code.Method))) (Map.insert "code" (DynT (typeof :: Type (Code.Code))) (Map.insert "statement" (DynT (typeof :: Type (Code.Statement))) (Map.insert "if" (DynT (typeof :: Type (Code.If))) (Map.insert "condition" (DynT (typeof :: Type (Code.Condition))) (Map.insert "else" (DynT (typeof :: Type (Code.Else))) (Map.insert "throw" (DynT (typeof :: Type (Code.Throw))) (Map.insert "return" (DynT (typeof :: Type (Code.Return))) (Map.insert "assignment" (DynT (typeof :: Type (Code.Assignment))) (Map.insert "declaration" (DynT (typeof :: Type (Code.Declaration))) (Map.insert "left" (DynT (typeof :: Type (Code.Left))) (Map.insert "right" (DynT (typeof :: Type (Code.Right))) (Map.empty))))))))))))))))))))))))))))))
