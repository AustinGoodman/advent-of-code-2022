import System.IO  
import Control.Monad

-- convert a character to an integer
charAsInt :: Char -> Integer
charAsInt char = read [char]

-- convert a line of input to a list of moves
moveFromInput :: String -> [(Char, Integer)]
moveFromInput inputString = moves where
    inputLines = lines inputString
    moves = map (\line -> (head line, read (tail line))) inputLines

-- clamp a number between a lower and upper limit
clamp :: Integer -> Integer -> Integer -> Integer
clamp lowerLim upperLim n = max lowerLim (min upperLim n)

-- add two vectors
vadd :: (Integer, Integer) -> (Integer, Integer) -> (Integer, Integer)
vadd (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

-- subtract two vectors
vsub :: (Integer, Integer) -> (Integer, Integer) -> (Integer, Integer)
vsub (x1, y1) (x2, y2) = (x1 - x2, y1 - y2)

vmul :: (Integer, Integer) -> Integer -> (Integer, Integer)
vmul (x, y) n = (x * n, y * n)

-- square a vector
vsquared :: (Integer, Integer) -> Integer
vsquared (x, y) = x^2 + y^2

-- take a vector and return a list of unit vectors that add up to the original vector
subVecsFromVec :: (Integer, Integer) -> [(Integer, Integer)]
subVecsFromVec (x, y) = unitVecs where
    unitVecs'' = [(x', y') | x' <- [0..abs(x)], y' <- [0..abs(y)]]

    -- correct for negative vectors
    unitVecs' = map (\(x', y') -> (signum x * min x' 1, signum y * min y' 1)) unitVecs''

    -- filter out zero vectors
    unitVecs = filter (\(x', y') -> x' /= 0 || y' /= 0) unitVecs'

-- take a move and return a vector representing the move
vecFromMove :: (Char, Integer) -> (Integer, Integer)
vecFromMove ('U', n) = (0, n)
vecFromMove ('D', n) = (0, -n)
vecFromMove ('R', n) = (n, 0)
vecFromMove ('L', n) = (-n, 0)

-- take a head position and a tail position and return a vector representing the translation of the tail
tailTranslation :: (Integer, Integer) -> (Integer, Integer) -> (Integer, Integer)
tailTranslation (h1, h2) (t1, t2) = translationVec where
    separation = vsub (h1, h2) (t1, t2)
    translationVec = 
        if (vsquared separation <= 2) 
            then (0, 0) 
        else 
            (\(x, y) -> (clamp (-1) 1 x, clamp (-1) 1 y)) separation

nextTailPos :: (Integer, Integer) -> (Integer, Integer) -> (Integer, Integer)
nextTailPos headPos tailPos = vadd tailPos (tailTranslation headPos tailPos)


main = do
    fileHandle <- openFile "./input.txt" ReadMode

    input <- hGetContents fileHandle

    let moves = moveFromInput input
    let moveVecs = map vecFromMove moves
    let subMoveVecs = concat (map subVecsFromVec moveVecs)
    
    let headPoses = scanl vadd (0, 0) subMoveVecs

    --for each head position, calculate the next tail position
    let tailPoses = foldl (\acc x -> acc ++ [nextTailPos x (last acc)]) [(0, 0)] headPoses

    -- part 1
    let uniqueTailPoses = foldl (\acc x -> if (elem x acc) then acc else acc ++ [x]) [] tailPoses
    print (length uniqueTailPoses)
    
    -- part 2
    let tailPoses2 = foldl (\acc x -> acc ++ [nextTailPos x (last acc)]) [(0, 0)] tailPoses
    let tailPoses3 = foldl (\acc x -> acc ++ [nextTailPos x (last acc)]) [(0, 0)] tailPoses2
    let tailPoses4 = foldl (\acc x -> acc ++ [nextTailPos x (last acc)]) [(0, 0)] tailPoses3
    let tailPoses5 = foldl (\acc x -> acc ++ [nextTailPos x (last acc)]) [(0, 0)] tailPoses4
    let tailPoses6 = foldl (\acc x -> acc ++ [nextTailPos x (last acc)]) [(0, 0)] tailPoses5
    let tailPoses7 = foldl (\acc x -> acc ++ [nextTailPos x (last acc)]) [(0, 0)] tailPoses6
    let tailPoses8 = foldl (\acc x -> acc ++ [nextTailPos x (last acc)]) [(0, 0)] tailPoses7
    let tailPoses9 = foldl (\acc x -> acc ++ [nextTailPos x (last acc)]) [(0, 0)] tailPoses8
    let uniqueTailPoses9 = foldl (\acc x -> if (elem x acc) then acc else acc ++ [x]) [] tailPoses9

    print (length uniqueTailPoses9)

    hClose fileHandle