

#==================================================
#           Applied Econometrics using R
#                  VCREME Course
#  Section 1: Data Manipulation / Visualization
#==================================================

#---------------------------------
#       Install R packages
#   and set working directory
#---------------------------------


# An example of Installing a package from CRAN: 
install.packages("AER", dependencies = TRUE)


# An example of installing a package from GitHub: 
library("devtools")
install_github("kassambara/factoextra")


# Show current working directory: 
getwd()

# Create a new folder: 
dir.create("F:/KTLR")

# Set working directory: 
setwd("F:/KTLR")

# Inspect your working directory: 
path <- dir("F:/KTLR", full.names = TRUE)
length(path)
head(path)
tail(path)

#-----------------------
#     Data Structure
#-----------------------

# Using c() fuction for creating a vector: 

nation <- c("Indonesia", "Thailand", "Philippines")
gdp <- c(12378, 17786, 8229)

# Using class() or str() for inspecting type of vector (or any objects in R): 
str(gdp) 
str(nation) 

class(gdp) 
class(nation)

# Create a logical vector: 
muslim <- c(TRUE, FALSE, FALSE)

# Create a factor vector by using factor() function: 
nation_f <- factor(c("Indonesia", "Thailand", "Philippines"))

# Create a data frame from vectors: 

df1 <- data.frame(nation, gdp, muslim)

# Inspect our DF:
names(df1)
dim(df1)
nrow(df1)
ncol(df1)

# Create a list: 
my_list1 <- list(nation, df1, gdp) 
my_list2 <- list(nation, gdp)


# Access to a column of data frame: 
df1$nation
df1$muslim
df1$gdp

a <- df1$gdp

str(a)
str(df1$gdp)

# Access to an element of list: 

m <- my_list1[[1]]
n <- my_list1[[2]]

str(m)
str(n)

#==================
#   Import Data
#==================



#---------------------------------
# From Stata files (.DTA / .dta)
#---------------------------------

library(haven)
using_haven <- read_stata("Panel1.dta")

head(using_haven)
tail(using_haven)
dim(using_haven)
str(using_haven)
View(using_haven)
summary(using_haven)

#---------------------------------
#     From SPSS files (.sav)
#---------------------------------

# Usingn read_spss(): 

spss_haven <- read_spss("chicken.sav")
head(spss_haven)
str(spss_haven)
summary(spss_haven)


# Using read.spss() from foreign package: 

library(foreign)
spss_fore <- read.spss("chicken.sav", to.data.frame = TRUE)
head(spss_fore)
str(spss_fore)
summary(spss_fore)



#-----------------------------
#   From Eviews Files
#-----------------------------

library(hexView)
from_eviews <- readEViews("ch4bt8.wf1", as.data.frame = TRUE)
head(from_eviews)


#-------------------------------------------------
#     From Excel files (.xlsx, .xls, .csv): 
#     See 2.3.5 Applied Econometrics using R
#-------------------------------------------------

library(readxl)
from_xls <- read_excel("Table2_8.xls")
from_xlsx <- read_excel("luong.xlsx", sheet = 1)


#----------------------------
#   Import Large Data
#----------------------------

# Use read.csv() from R base: 
c1 <- read.csv("flights.csv")
dim(c1)
head(c1)

# Use read_csv() from readr package: 
library(tidyverse)
c2 <- read_csv("flights.csv")


# Use fread() from data.tabe package: 
library(data.table)
c3 <- fread("flights.csv")

system.time(c1 <- read.csv("flights.csv"))
system.time(c2 <- read_csv("flights.csv"))
system.time(c3 <- fread("flights.csv"))

#------------------------------
#    Import multiple files
#------------------------------

# Stage 1: Direct path: 

path_stocks <- dir("F:/KTLR/cophieu", full.names = TRUE) 
path_stocks

# Stage 2: Use lapply() and read_csv() function: 
all_stocks <- lapply(path_stocks, read_csv)
str(all_stocks)

# State 3: Convert to data frame using do.call() function: 

my_df <- do.call("rbind", all_stocks)
str(my_df)
View(my_df)


#-----------------------------------------------
#     From Internet or data base
#     http://datacatalog.worldbank.org 
#     See 2.3.9 Applied Econometrics using R
#-----------------------------------------------



#=====================================
#    Data Wrangling / Manipulation
#=====================================

#------------------------------------------
#     Data Frame vs Tibble (Data_frame)
#------------------------------------------

summary(c1)
summary(c2)

str(c1)
str(c2)


#----------------------
#    Pipe Operator
#----------------------

# Load package for using pipe: 
library(magrittr)

c1 %>% summary()

c4 <- "flights.csv" %>% read.csv()
c4 %>% summary()
c1 %>% head()
c1 %>% str()

#-------------------------------------------------
#    You must master: 
#    1. filter()
#    2. select()
#    3. mutate()
#    4. rename()
#    5. arrange()
#    6. group_by()
#    7. gather()
#    8. summarise_each() / summarise family
#    9. case_when() 
#    10. slice() / sample_n() / sample_frac()
#    11. count()
#    12. pull()
#-------------------------------------------------

library(tidyverse)


# Inspect data set: 
from_eviews %>% head()
from_eviews %>% tail()

head(from_eviews)
tail(from_eviews)

from_eviews %>% dim()
from_eviews %>% names()


# rename() function: 

df1 <- rename(from_eviews, Age = AGE, Urban = URBAN)
df1 %>% head()

df1 <- from_eviews %>% rename(Age = AGE, Urban = URBAN)
df1 %>% head()

# select() function: 

df2 <- select(from_eviews, AGE, IQ, WAGE)
head(df2)

df2 <- from_eviews %>% select(AGE, IQ, WAGE)
df2 %>% head()

df3 <- from_eviews %>% select(contains("E"))
df3 %>% head()


df4 <- from_eviews %>% select(-AGE, -EDUC)
df4 %>% head()

df5 <- from_eviews %>% select(-contains("E"))
df5 %>% head()

df6 <- from_eviews %>% select(AGE)


# pull(): 
df7 <- from_eviews %>% pull(AGE)

str(df7)
str(df6)

# mutate(): 

df8 <- from_eviews %>% mutate(AGE2 = AGE^2, 
                              UBSO = SOUTH*URBAN, 
                              DELTA = FEDUC - MEDUC)
df8 %>% head()


df9 <- from_eviews %>% transmute(AGE2 = AGE^2, 
                                 UBSO = SOUTH*URBAN, 
                                 DELTA = FEDUC - MEDUC)

df9 %>% head()


# case_when(): 

df10 <- from_eviews %>% mutate(MALE = case_when(MALE == 1 ~ "Male", 
                                                MALE == 0 ~ "Female"))

df10 %>% head()

df11 <- from_eviews %>% mutate(TYPE = case_when(WAGE <= 3169 ~ "GroupA", 
                                                WAGE > 3169 & WAGE <= 3458 ~ "GroupB", 
                                                WAGE > 3458 ~ "GroupC"))


df11 %>% head()

df10$MALE %>% table()
from_eviews$MALE %>% table()

df11$TYPE %>% table()

# slice(): 

df12 <- from_eviews %>% slice(1:3)
df12

df13 <- from_eviews %>% slice(c(1:3, 99, 200))
df13


df14 <- from_eviews %>% sample_n(5)
df14

set.seed(1)
df15 <- from_eviews %>% sample_n(4)
df15

set.seed(2)
df16 <- from_eviews %>% sample_frac(0.01)

dim(df16)
0.01*nrow(from_eviews)





