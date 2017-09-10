import System.Environment

main = do
     [f] <- getArgs                            --get file name from argument
     content <- readFile f                     --read file
     let fileLines = lines content             --take lines
     let numCandidates = head fileLines        --head of lines means number of candidates
     let (nameCandidates , ballot) = nameOfCandidates numCandidates fileLines  --nameOfCandidates functions returns name of candidates and ballots
     let numBallots = toInteger(length ballot) --number of ballots
     let processedVotes = calculate [1..(read numCandidates::Integer)] (stringListToIntListList ballot)  --calculate returns which votes will be calculated on first round
     let votes = filter (\x -> notElem x [0]) processedVotes                                          --take out zero which is added for error checking
     let votesOfCandidates = countVotes [1..(read numCandidates::Integer)] votes                      --count how many votes each candidate has
     let result = australianVoting votesOfCandidates nameCandidates [1..(read numCandidates::Integer)] numBallots ballot  --take rounds until there is a winner or all candidates are tied
     putStrLn result                            --return result

--The votes given to each candidate are counted
countVotes :: [Integer] -> [Integer] -> [Integer]
countVotes candidateList votes = map countEach candidateList
     where
      countEach :: Integer -> Integer
      countEach candidate = toInteger (length $ filter (==candidate) votes)
      
--If there is a candidate who receives more than %50 of the vote, return its index on name list. Otherwise, return -1
getWinner :: Integer -> [Integer] -> Int
getWinner numBallots votes = if null (filter(>(numBallots `div` 2)) votes) then -1 else head (findIndex (head (filter(>(numBallots `div` 2)) votes)))
     where
      findIndex ::  Integer -> [Int]
      findIndex i = map fst $ filter ((i==).snd) $ zip [0..] votes

--The minimum number of votes given to candidates are calculated
findMinimumVotes :: [Integer] -> [(Integer,Integer)]
findMinimumVotes votes = filter (\ (_,x) -> x == minimum votes) (zip [1..] votes)

--return which candidate lost according to votes on that round
losers :: [Integer] -> [Integer]
losers = map fst . findMinimumVotes

--return name of candidates and ballot
nameOfCandidates :: String -> [String] -> ([String],[String])
nameOfCandidates count xs = splitAt (read count :: Int) (tail xs)

--tie candidates which lost election
tieCandidates :: [Integer] -> [String] -> [String]
tieCandidates loserIndexes candidateNames= map tie loserIndexes
     where
      tie :: Integer -> String
      tie x = candidateNames !! (fromIntegral x -1 ::Int)
--calculate which votes will be calculated on that round
calculate :: [Integer] -> [[Integer]] -> [Integer]
calculate candidateList ballot = map nonEliminated ballot
    where
     nonEliminated :: [Integer] -> Integer
     nonEliminated zs = case zs of
      [] -> 0
      z:zs' -> if (elem z candidateList) then z else nonEliminated zs'
      
--convert string list to integer list
stringListToIntListList :: [String] -> [[Integer]]
stringListToIntListList xs = map stringToIntList xs

--convert string to integer list
stringToIntList :: String -> [Integer]
stringToIntList str = map read $ words str

--check if there is a winner or all candidates are tied
australianVoting :: [Integer] -> [String] -> [Integer] -> Integer -> [String] -> String
australianVoting votes names candidates numBallots ballots
     | length ( tieCandidates (losers votes) names ) == length (votes) = concat ( tieCandidates (losers votes) names )
     | (getWinner numBallots votes) == -1 = australianVoting (countVotes (eliminate (losers votes)(candidates) ) (calculate (eliminate (losers votes) (candidates)) (stringListToIntListList ballots))) names candidates numBallots ballots
     | otherwise = names !! (getWinner numBallots votes)
     
--Eliminate given candidates from candidates list    
eliminate :: [Integer] -> [Integer] -> [Integer]
eliminate removed candidates = filter (\x -> notElem x removed) candidates

