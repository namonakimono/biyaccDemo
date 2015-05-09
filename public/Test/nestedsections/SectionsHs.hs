{-# LANGUAGE DeriveGeneric, TemplateHaskell #-}

module Bookmark where
	
import Generics.Putlenses.Language
import Generics.Putlenses.TH
import Generics.Putlenses.Putlens
import GHC.Generics
import GHC.InOut
import Data.List
import Generics.Putlenses.Examples.Examples

data Section = Section Title Paragraph [Subsection] deriving (Eq,Show,Generic)
data Subsection = Subsection Title Paragraph deriving (Eq,Show,Generic)
data Paragraph = Paragraph String deriving (Eq,Show,Generic)
data Title = Title String deriving (Eq,Show,Generic)
$( makePutlensConstructors ''Section)
$( makePutlensConstructors ''Subsection)
$( makePutlensConstructors ''Paragraph)
$( makePutlensConstructors ''Title)

data Sec = Sec String [Sub] deriving (Eq,Show,Generic)
data Sub = Sub String deriving (Eq,Show,Generic)
$( makePutlensConstructors ''Sec)
$( makePutlensConstructors ''Sub)

s = [s1,s2]
s1 = Section (Title "Grand Tours") (Paragraph "The grand tours are major cycling races...") [ss1]
ss1 = Subsection (Title "Giro d'Italia") (Paragraph "The Giro is usually held in May and June...")
s2 = Section (Title "Classics") (Paragraph "The classics are one-day cycling races...") [ss2]
ss2 = Subsection (Title "Milan-San Remo") (Paragraph "The Spring classic is held in March...")

v' = [v1',v2']
v1' = Sec "Classics" [Sub "Milan-San Remo",Sub "Paris-Roubaix"]
v2' = Sec "Grand Tours" [Sub "Giro d'Italia", Sub "Tour de France"]

v'' = [v1'',v2'']
v1'' = Sec "Classics" []
v2'' = Sec "Grand Tours" [Sub "Giro d'Italia", Sub "Milan-San Remo"]

secsPut :: Putlens st e [Section] [Sec]
secsPut = withS $ mapPut (sectionPut .< assocrPut .< (addsndPut paragraphOf ><< idPut) .< (titlePut ><< subsecsPut) .< unsecPut)
    where paragraphOf st secs v = case find (\(Section t p _) -> t == v) secs of
	        { Just (Section t p _) -> p; Nothing -> Paragraph "" }

subsecsPut :: Putlens st e [Subsection] [Sub]
subsecsPut = withS $ mapPut (subsectionPut .< addsndPut paragraphOf .< titlePut .< unsubPut)
    where paragraphOf st subsecs v = case find (\(Subsection t p) -> t == v) subsecs of
	        { Just (Subsection t p) -> p; Nothing -> Paragraph "" } 

-----

secsPut2 :: Putlens st e [Section] [Sec]
secsPut2 = withS $ initSt (\st secs v -> (secs,subsecs secs)) secsPut2'
    where subsecs secs = concatMap (snd . snd . out) secs

secsPut2' :: Putlens ([Section],[Subsection]) e [Section] [Sec]
secsPut2' = mapPut (sectionPut .< assocrPut .< (addsndPut paragraphOf ><< idPut) .< (titlePut ><< subsecsPut2') .< unsecPut)
    where paragraphOf (secs,subsecs) e v = case find (\(Section t p _) -> t == v) secs of
	        { Just (Section t p _) -> p; Nothing -> Paragraph "" }

subsecsPut2' :: Putlens ([Section],[Subsection]) e [Subsection] [Sub]
subsecsPut2' = mapPut (subsectionPut .< addsndPut paragraphOf .< titlePut .< unsubPut)
    where paragraphOf (secs,subsecs) e v = case find (\(Subsection t p) -> t == v) subsecs of
	        { Just (Subsection t p) -> p; Nothing -> Paragraph "" }


ex1 = put (put2lens secsPut) s v'
ex2 = put (put2lens secsPut) s v''

ex3 = put (put2lens secsPut2) s v'
ex4 = put (put2lens secsPut2) s v''


	