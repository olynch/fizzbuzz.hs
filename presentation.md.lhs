% FizzBuzz In Haskell
% Owen Lynch
% April 25th 2018
\newcommand{\ignore}[1]{}
\ignore{

> {-# LANGUAGE NoImplicitPrelude #-}
> 
> module Presentation where
> 
> import Prelude hiding (Monoid, mappend, mempty, (<>), map, range, Just, Nothing, Maybe, repeat, zipWith, mconcat, foldl, String, (.))

}

== Introducing Haskell

> fact :: Int -> Int
> fact 0 = 1
> fact n = n * fact (n-1)

Equivalent python code:

~~~{.python}
def fact(n):
  if n == 0:
    return 1
  else:
    return n*(fact(n-1))
~~~

. . .

Notable Features

. . .

- Types
- Pattern Matching

== The Anatomy of a Haskell Definition

Type Signature

![](factTypeSignature.png){ width=50% }

== The Anatomy of a Haskell Definition

Name

![](factName.png){ width=50% }

== The Anatomy of a Haskell Definition

Type

![](factType.png){ width=50% }

== The Anatomy of a Haskell Definition

Definition

![](factDefinition.png){ width=50% }

== The Anatomy of a Haskell Definition

Argument

![](factArgument.png){ width=50% }

== The Anatomy of a Haskell Definition

Value

![](factValue.png){ width=50% }

== Myths about Haskell

- Haskell is hard
  - *Learning* Haskell is hard, *programming* Haskell is easy!
  - Haskell lets you choose the level of abstraction that you are comfortable with, and you can slowly increase this while being productive the whole time
- Haskell is for techbro superprogrammers
  - Haskell is for people who can't keep lots of stuff in their head at once and want the compiler to make sure they aren't messing things up
  - The Haskell community is one of the nicest and friendliest online communities I've been a part of, in part because there is so much to learn that everyone is comparatively a noob
- Haskell is for academic ivory-towerists who do too much category theory for their own good
  - Haskell is actually a very practical language for all sorts of tasks, and it has been battletested in industry for decades

== However...

- In this talk we will not be doing anything practical.
- This is a silly tour of some neat features in Haskell.
- I am not expecting all of this talk to make sense to you right away.
- When you see something you don't understand, don't think "Agghhh Haskell is way to hard", think "Cool, I have something to figure out!"

== Introducing FizzBuzz

- Make a list of the numbers from 1 to 100, except...
  - For every number divisible by 3, put "Fizz" instead
  - For every number divisible by 5, put "Buzz" instead
  - For every number divisible by 5 and 3, put "FizzBuzz" instead
- How would you solve FizzBuzz?


== Lists

How can we make a list until we know what a list *is*??

. . .

![](lists.jpg){ width=50% }

== Lists in Python

~~~{.python}
class ConsCell:
  def __init__(head, tail)
    self.head = head
    self.tail = tail

class EmptyList:
  def __init__():
    return

oneTwo = ConsCell(1, ConsCell(2, EmptyList))
~~~

== Lists in Haskell

< data [a] = [] | a : [a]
< -- data List a = Empty | Cons a (List a)
< -- (:) x xs == x : xs
< -- ([]) a = [a]

> firstFourPrimes :: [Int]
> firstFourPrimes = 2:(3:(5:(7:[])))
>
> type String = [Char]
> -- "abc" = 'a':('b':('c':[]))
> 
> everyFlavoredBeanFlavors :: [String]
> everyFlavoredBeanFlavors =
>   ["earwax", "marmalade", "spinach"]

== How do we work with it?

Recursion!

Our first step is generating all of the numbers from 1 to 100.

> range :: Int -> Int -> [Int]
> range n m
>   | n == m    = [n]
>   | otherwise = n:(range (n+1) m)
> -- range n m == [n..m]

. . .

- New stuff:
  - Currying
  - Guard Notation

== List Transformations

Now, we need to do something to each of those numbers.

> map :: (a -> b) -> [a] -> [b]
> map f [] = []
> map f (x:xs) = (f x):(map f xs)

. . .

- New stuff:
  - Functions applied to functions!

== The first solution

> fizzbuzz1 :: Int -> String
> fizzbuzz1 n
>   | rem n 15 == 0 = "FizzBuzz"
>   | rem n  5 == 0 = "Buzz"
>   | rem n  3 == 0 = "Fizz"
>   | otherwise     = show n
>
> sol1 :: [String]
> sol1 = map fizzbuzz1 [1..100]

== Discuss first solution

- What did we like?
  - Recursion!
  - Combinators that allowed us to not do recursion!
  - Case syntax!
- What did we not like?
  - Not extensible enough! (What about Bazz??)

== FizzBuzzBazz

> fizzbuzzbazz1 :: Int -> String
> fizzbuzzbazz1 n
>   | rem n 105 == 0 = "FizzBuzzBazz"
>   | rem n  35 == 0 = "BuzzBazz"
>   | rem n  21 == 0 = "FizzBazz"
>   | rem n  15 == 0 = "FizzBuzz"
>   | rem n   7 == 0 = "Bazz"
>   | rem n   5 == 0 = "Buzz"
>   | rem n   3 == 0 = "Fizz"
>   | otherwise      = show n

. . .

This is terrible!

== How should we solve this?

- We need to be able to compose different "zz"s
- To do this, we will use a common structure for composing things
- We need...
  - A data type
  - A way of putting two elements of that data type together
  - A neutral element that doesn't change other elements when you compose with it
- That's a recipe for a...
- Monoid!

== Monoid Hype

"Monoids are ubiquitous throughout programming. The difference is that in Haskell we recognize and talk about them."

-- Real World Haskell

\vspace{1cm}

\pause
\begin{figure}
  \centering
  \begin{minipage}{.5\textwidth}
    \centering
    \includegraphics[width=0.9\linewidth]{monoids-monoids-everywhere.jpg}
  \end{minipage}%
  \pause%
  \begin{minipage}{.5\textwidth}
    \centering
    \includegraphics[width=0.9\linewidth]{monoid-mary.png}
  \end{minipage}
\end{figure}

== You already know lots of monoids!

Take a couple minutes and think of monoids

. . .

- Strings or lists with concatenation
- Bytes with `AND` and `11111111` 
- Bytes with `OR` and `00000000`
- Functions `f :: a -> a` along with composition and the identity function
- Any type of number ($\mathbb{N}$, $\mathbb{Z}$, $\mathbb{Q}$, $\mathbb{R}$, $\mathbb{C}$) along with addition
- Any type of number along with multiplication
- Any ordered set along with max and a "negative infinity" element as identity
- Any ordered set along with min and a "positive infinity" element as identity

== Some nitty-gritties...

In Haskell, we write the definition of a Monoid like this

> class Monoid m where
>   mempty :: m
>   (<>) :: m -> m -> m

Unfortunately, we can't write down the laws... we just have to trust that whenever someone implements a Monoid they make sure they satisfy them!

== List Monoid

> instance Monoid [a] where
>   mempty = []
>   [] <> ys = ys
>   (x:xs) <> ys = x:(xs <> ys)

== Maybe Monoid

> data Maybe a = Just a | Nothing
>
> instance (Monoid a) => Monoid (Maybe a) where
>   mempty = Nothing
>   Nothing <> Nothing = Nothing
>   (Just a) <> Nothing = Just a
>   Nothing <> (Just b) = Just b
>   (Just a) <> (Just b) = Just (a <> b)

== Working with Maybes

> fromMaybe :: a -> Maybe a -> a
> fromMaybe def Nothing = def
> fromMaybe _ (Just y) = y

== Combining lists

> foldl :: (a -> b -> a) -> a -> [b] -> a
> foldl f acc [] = acc
> foldl f acc (x:xs) = foldl f (f acc x) xs
> -- sum == foldl (+) 0
> -- length == foldl (\n _ -> n + 1) 0
>
> mconcat :: (Monoid m) => [m] -> m
> mconcat = foldl (<>) mempty
> -- mconcat ["tweedle", "dee"] == "tweedledee"

== FizzBuzz Revisited

> fizzbuzz2 :: [(Int, String)] -> Int -> String
> fizzbuzz2 conds n = fromMaybe (show n) mdesc
>   where
>     mdesc = mconcat (map maybeWord conds)
>     maybeWord (k, word)
>       | rem n k == 0 = Just word
>       | otherwise    = Nothing
>
> sol2 :: [String]
> sol2 = map (fizzbuzz2 conds) [1..100]
>   where conds = [(3, "Fizz"), (5, "Buzz")]

== Reflections on take 2

- What do we like?
  - Monoids!
  - Currying!
  - Much more extensible!
- What do we not like?
  - Still not extensible enough!

== FizzBuzz: Hard Mode
  - FizzBuzz, but...
    - For every prime number, put "Buzz" instead
    - For every fibonacci number, put "Fizz" instead
    - For every number that is a fibonacci number and a prime number, put "FizzBuzz" instead

== Infinity and Beyond!

> repeat :: a -> [a]
> repeat x = x:(repeat x)
> -- take 3 (repeat 1) = [1,1,1]

== Infinite list illustration

![](repeat1.jpg){ width=50% }

== Infinite list illustration

![](repeat2.jpg){ width=50% }

== Generating prime numbers

> primes :: [Int]
> primes = from 2
>   where
>     from k = k:(filter (ndiv k) (from (k+1)))
>     ndiv k n = rem n k /= 0
> -- take 4 primes == [2,3,5,7]

== An illustration of `primes`

![](primes1.jpg){ width=50% }

== An illustration of `primes`

![](primes2.jpg){ width=50% }

== An illustration of `primes`

![](primes3.jpg){ width=50% }

== Zipping Lists

> zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
> zipWith _ [] _ = []
> zipWith _ _ [] = []
> zipWith f (x:xs) (y:ys) =
>   (f x y):(zipWith f xs ys)

== The zipWith Monster!

![](zipWith1.jpg){ width=50% }

== The zipWith Monster!

![](zipWith2.jpg){ width=50% }

== Fibonacci numbers

> fibs :: [Int]
> fibs = 1:2:(zipWith (+) fibs (tail fibs))
> -- This one's a braintwister!

== The Fibonacci zipWith Monster!

![](fibZipWith1.jpg){ width=50% }

== The Fibonacci zipWith Monster!

![](fibZipWith2.jpg){ width=50% }

== Lists as Monoids Revisited

> newtype Stream a = S [a]
> 
> unS :: Stream a -> [a]
> unS (S xs) = xs
>
> instance Monoid a => Monoid (Stream a) where
>   mempty = S []
>   (S []) <> (S ys) = S ys
>   (S xs) <> (S []) = S xs
>   (S (x:xs)) <> (S (y:ys)) = S ((x <> y):rest)
>     where (S rest) = (S xs) <> (S ys)

Conceptually, when the list ends, we treat the rest as an infinite stream of `mempty`s (this might make more sense in the context of the next slide)

== Thoughts on Streams

`Stream Double` is a vector space, where Double is the type of real numbers (OK, floating point numbers) in Haskell.

< scalarMult :: Double -> Stream Double -> Stream Double
< scalarMult r (S xs) = S (map (r*) xs)
<
< addV :: Stream Double -> Stream Double -> Stream Double
< addV = (<>)
< -- The monoid instance for Double uses addition
<
< negV :: Stream Double -> Stream Double
< negV = scalarMult (-1)

This is the same thing as the vector space of polynomials of one variable over $\mathbb{R}$.

$[1,0,\pi] \approx 1 + \pi x^2$

== FizzBuzz: The Final Showdown (Part 1)

> spacer :: [Int] -> a -> [Maybe a]
> spacer (n:ns) x = loop (n-1) (n:ns)
>   where
>     loop 0 (k1:k2:ns) =
>       (Just x):(loop (k2-k1-1) (k2:ns))
>     loop k ns = Nothing:(loop (k-1) ns)
>
> -- spacer [1,3,4,7,...] 'x' ==
> --   [Just 'x', Nothing, Just 'x', Just 'x', Nothing
> --    Nothing, Just 'x',...]

== FizzBuzz: The Final Showdown (Part 2)

> (.) :: (b -> c) -> (a -> b) -> (a -> c)
> (f . g) x = f (g x)
> -- We need the Monoid instance for a because we need
> -- a monoid instance for Stream (Maybe a), which we
> -- need because of mconcat
> combine :: (Monoid a) => [([Int], a)] -> [Maybe a]
> combine = unS . mconcat . map (S . uncurry spacer)
> -- uncurry spacer :: ([Int], a) -> [Maybe a]
>
> sol3 :: [String]
> sol3 = zipWith fromMaybe (map show [1..100]) descs
>   where descs = combine [(primes,"Fizz"), (fibs,"Buzz")]

== Reflecting on the Final Showdown

- What we liked
  - Really really extensible!
  - Argument-free function definition!
- What we didn't like
  - Really hard to understand!
- There should always be a balance, no matter what your programming language is. The difference is, in Haskell you have many more choices about how you balance.

== Resources

- Resources for learning haskell
  - Learn You a Haskell for Great Good
    - FREE online at learnyouahaskell.com
  - Haskell Programming From First Principles
    - REALLY GOOD, NOT FREE, online at haskellbook.com
  - Real World Haskell
    - PRETTY GOOD, FREE, google for pdf or email me
- Resources for using Haskell
  - stack, a package manager for Haskell
    - haskellstack.org
  - haskell.org, the center of all things Haskell
  - hoogle, a search engine for functions, data types, etc. (REALLY USEFUL)

== Thank You

. . .

Shout out to my beta testers Max, Megan and Shelley, who gave me some really good feedback! If you understood this talk, it was entirely their fault.

. . .


Shriram (against his better judgement) sponsored this talk, convincing the CS department to let me book this room.

. . .

Monoid Mary (Julie Moronuki) allowed me to quote her and also gave me the quote from Real World Haskell.

. . .

Thank you all for coming and being curious!

