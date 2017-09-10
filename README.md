# AustralianVoting
This exercise (Australian voting) is taken from the book "Programming Challenges" by Steven S. Skiena and Miguel A. Revilla. Australian ballots require that voters rank all candidates in order of choice. Initially only the first choices are counted, and if one candidate receives more than 50% of the votes then that candidate is elected. However, if no candidate receives more than 50%, all candidates tied for the lowest number of votes are eliminated. Ballots ranking these candidates first are recounted in favor of their highest-ranked non-eliminated candidate. This process of eliminating the weakest candidates and counting their ballots in favor of the preferred non-eliminated candidate continues until one candidate receives more than 50% of the vote, or until all remaining candidates are tied. The input to your program will be a text file that begins with an integer n ≤ 20 indicating the number of candidates. The next n lines consist of the names of the candidates in order. Up to 1,000 lines follow, each containing the contents of a ballot. Each ballot contains the numbers from 1 to n in some order. The first number indicates the candidate of first choice; the second number indicates candidate of second choice, and so on. The output message will consist of either a single line containing the name of the winner or several lines containing the names of all candidates who are tied.

Sample input file contents:

3 

John Doe 

Jane Smith 

Jane Austen 

1 2 3 

2 1 3 

2 3 1 

1 2 3 

3 1 2 

Sample output in this case: John Doe 

You have to make sure that your program can be compiled and run from the command line (not only from within ghci as in: 

./australian_voting votes.txt
