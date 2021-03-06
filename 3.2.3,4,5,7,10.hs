module Demo where
import Data.Char

{-
Напишите функцию readDigits, принимающую строку и возвращающую пару строк.
Первый элемент пары содержит цифровой префикс исходной строки, а второй - ее оставшуюся часть.
GHCi> readDigits "365ads"
("365","ads")
GHCi> readDigits "365"
("365","")
В решении вам поможет функция isDigit из модуля Data.Char.
-}

readDigits :: String -> (String, String)
readDigits = span Data.Char.isDigit

{-
Реализуйте функцию filterDisj, принимающую два унарных предиката и список, и возвращающую список элементов, удовлетворяющих хотя бы одному из предикатов.

GHCi> filterDisj (< 10) odd [7,8,10,11,12]
[7,8,11]
-}
filterDisj :: (a -> Bool) -> (a -> Bool) -> [a] -> [a]
filterDisj p1 p2 = filter (\x -> p1 x || p2 x)

{-
Напишите реализацию функции qsort. Функция qsort должная принимать на вход список элементов и сортировать его в порядке возрастания с помощью сортировки Хоара: для какого-то элемента x изначального списка (обычно выбирают первый) делить список на элементы меньше и не меньше x, и потом запускаться рекурсивно на обеих частях.

GHCi> qsort [1,3,2,5]
[1,2,3,5]
Разрешается использовать только функции, доступные из библиотеки Prelude.
-}
qsort' :: Ord a => [a] -> [a]
qsort' [] = []
qsort' [a] = [a]
qsort' as@(h:as') = 
    qsort' small ++ middle ++ qsort' large
    where 
        small = filter (< h) as
        middle = filter (== h) as
        large = filter (> h) as



{-
Напишите функцию squares'n'cubes, принимающую список чисел, 
и возвращающую список квадратов и кубов элементов исходного списка.
GHCi> squares'n'cubes [3,4,5]
[9,27,16,64,25,125]
-}

squares'n'cubes :: Num a => [a] -> [a]
squares'n'cubes = concat . (map (\x -> (x^2):(x^3):[]))
    
{-
Воспользовавшись функциями map и concatMap, определите функцию perms, которая возвращает все перестановки, которые можно получить из данного списка, в любом порядке.

GHCi> perms [1,2,3]
[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
Считайте, что все элементы в списке уникальны, и что для пустого списка имеется одна перестановка.
-}     
perms :: [a] -> [[a]]
perms [] = []   
perms [a] = [[a]]
perms (x:xs) = 
    let 
        blend a xs = (xs ++ [a]) : (iter' xs 0 [] (\x -> span' xs a x))

        span' xs a i = (fst (sp xs i)) ++ (a:(snd (sp xs i)))
        sp xs x = (take x xs, drop x xs) 

        --iter' i n acc f = if i == (n + 1) then acc else iter' (i+1) n (f acc i) f 
        iter' [] i acc f = acc
        iter' (x:xs) i acc f = iter' xs (i + 1) ((f i) : acc) f   
    in
        concatMap (\y -> blend x y) (perms xs)


-- blend a xs = (xs ++ [a]) : (iter' xs 0 [] (\x -> span' xs a x))

-- span' xs a i = (fst (sp xs i)) ++ (a:(snd (sp xs i)))
-- sp xs x = (take x xs, drop x xs) 

-- --iter' i n acc f = if i == (n + 1) then acc else iter' (i+1) n (f acc i) f 


-- iter' [] i acc f = acc
-- iter' (x:xs) i acc f = iter' xs (i + 1) ((f i) : acc) f   

{-
Реализуйте функцию delAllUpper, удаляющую из текста все слова, целиком состоящие из символов в верхнем регистре. Предполагается, что текст состоит только из символов алфавита и пробелов, знаки пунктуации, цифры и т.п. отсутствуют.

GHCi> delAllUpper "Abc IS not ABC"
"Abc not"
Постарайтесь реализовать эту функцию как цепочку композиций, аналогично revWords из предыдущего видео.
-}

delAllUpper :: String -> String
delAllUpper str = 
        unwords (filter (not . all' isUpper) (words str))
        where 
            all' p = and' . map p
            and' [] = True
            and' (x:xs) = x && and' xs 
{-
Напишите функцию max3, которой передаются три списка чисел одинаковой длины
и которая возвращает список чисел той же длины, содержащий на k-ой позиции
наибольшее значение из чисел на этой позиции в списках-аргументах.
GHCi> max3 [7,2,9] [3,6,8] [1,8,10]
[7,8,10]
-}

max3 :: Ord a => [a] -> [a] -> [a] -> [a]
max3 x y z = 
    map maximum (zip3' x y z)
    where
        zip3' _ _ [] = []
        zip3' _ [] _ = []
        zip3' [] _ _ = []
        zip3' (a:as) (b:bs) (c:cs) =
            (a:b:c:[]) : zip3' as bs cs
