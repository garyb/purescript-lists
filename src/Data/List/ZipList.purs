-- | This module defines the type of _zip lists_, i.e. linked lists
-- | with a zippy `Applicative` instance.

module Data.List.ZipList
  ( ZipList(..)
  , runZipList
  ) where

import Prelude
import Control.Alt (class Alt)
import Control.Alternative (class Alternative)
import Control.Plus (class Plus)
import Data.Foldable (class Foldable)
import Data.List.Lazy (List, repeat, zipWith)
import Data.Monoid (class Monoid, mempty)
import Data.Traversable (class Traversable)
import Partial.Unsafe (unsafeCrashWith)

-- | `ZipList` is a newtype around `List` which provides a zippy
-- | `Applicative` instance.
newtype ZipList a = ZipList (List a)

-- | Unpack a `ZipList` to obtain the underlying list.
runZipList :: forall a. ZipList a -> List a
runZipList (ZipList xs) = xs

instance showZipList :: Show a => Show (ZipList a) where
  show (ZipList xs) = "(ZipList " <> show xs <> ")"

derive newtype instance eqZipList :: Eq a => Eq (ZipList a)

derive newtype instance ordZipList :: Ord a => Ord (ZipList a)

derive newtype instance semigroupZipList :: Semigroup (ZipList a)

derive newtype instance monoidZipList :: Monoid (ZipList a)

derive newtype instance foldableZipList :: Foldable ZipList

derive newtype instance traversableZipList :: Traversable ZipList

derive newtype instance functorZipList :: Functor ZipList

instance applyZipList :: Apply ZipList where
  apply (ZipList fs) (ZipList xs) = ZipList (zipWith ($) fs xs)

instance applicativeZipList :: Applicative ZipList where
  pure = ZipList <<< repeat

instance altZipList :: Alt ZipList where
  alt = append

instance plusZipList :: Plus ZipList where
  empty = mempty

instance alternativeZipList :: Alternative ZipList

instance zipListIsNotBind
  :: Fail """
    ZipList is not Bind. Any implementation would break the associativity law.

    Possible alternatives:
        Data.List.List
        Data.List.Lazy.List
    """
  => Bind ZipList where
    bind = unsafeCrashWith "bind: unreachable"
