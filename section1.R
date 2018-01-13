

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

#--------------------------
#  1. rename() function 
#--------------------------

df1 <- rename(from_eviews, Age = AGE, Urban = URBAN)
df1 %>% head()

df1 <- from_eviews %>% rename(Age = AGE, Urban = URBAN)
df1 %>% head()

#-----------------------
# 2. select() function 
#-----------------------

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


#------------------------
#   3. pull() function
#------------------------

df7 <- from_eviews %>% pull(AGE)

str(df7)
str(df6)


#------------------------
#  4. mutate() function
#------------------------

df8 <- from_eviews %>% mutate(AGE2 = AGE^2, 
                              UBSO = SOUTH*URBAN, 
                              DELTA = FEDUC - MEDUC)
df8 %>% head()


df9 <- from_eviews %>% transmute(AGE2 = AGE^2, 
                                 UBSO = SOUTH*URBAN, 
                                 DELTA = FEDUC - MEDUC)

df9 %>% head()


#--------------------------
#  5. case_when() function
#--------------------------


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

#-------------------------------------------------------
#  6. slice() and sample_n() / sample_frac() function
#-------------------------------------------------------

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

#---------------------------------
#    7. arrange() function
#---------------------------------

# For numeric variables: 

df17 <- df16 %>% arrange(AGE)
df17 %>% head()

df18 <- df16 %>% arrange(desc(AGE)) # Method 1. 
df19 <- df16 %>% arrange(-AGE) # Method 2. 

df18 %>% head()
df19 %>% head()

df16 %>% 
  arrange(-AGE) %>% 
  head()

from_eviews %>% 
  arrange(-AGE) %>% 
  slice(c(1:5, 931:935)) # Not recommended.

from_eviews %>% 
  arrange(-AGE) %>% 
  slice(c(1:5, nrow(from_eviews) - 5:nrow(from_eviews))) # highly recommended. 

from_eviews %>% 
  arrange(-AGE) %>% 
  slice(c(1:5, nrow(.) - 5:nrow(.)))

# For character variables: 

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

df1 %>% arrange(nation)
df1 %>% arrange(desc(nation))

#-----------------------------
#   8. gather() function
#-----------------------------

# Create a data frame: 

panel_df <- data.frame(thoi_gian = c(2014, 2015, 2016), 
                       p_com_A = c(2, 3, 2), 
                       p_com_B = c(7, 5, 6))


panel_df

# Convert to long form: 
panel_long <- panel_df %>% gather(a, b, -thoi_gian)

panel_long 

# Rename for some columns: 
panel_long_rename <- panel_long %>% rename(symbol = a, price = b)
panel_long_rename 

# Hightly recommended: 

panel_long_c2 <- panel_df %>% gather(symbol, price,  -thoi_gian)
panel_long_c2

#----------------------------
#   9. group_by() function
#----------------------------

df11 %>% str()

df11 <- df11 %>% mutate(BLACK = case_when(BLACK == 1 ~ "Black", BLACK == 0 ~ "White"), 
                        MALE = case_when(MALE == 1 ~ "Male", MALE == 0 ~ "Female"), 
                        MARRIED = case_when(MARRIED == 1 ~ "Yes", MARRIED == 0 ~ "No"), 
                        SOUTH = case_when(SOUTH == 1 ~ "South", SOUTH == 0 ~ "North"), 
                        URBAN = case_when(URBAN == 1 ~ "Urban", URBAN == 0 ~ "Rural"))

df11 %>% str()

df11 %>% 
  group_by(MALE) %>% 
  count()

from_eviews %>% 
  group_by(MALE) %>% 
  count()

df11 %>% 
  group_by(MALE, BLACK) %>% 
  count()


df11 %>% 
  group_by(MALE, BLACK, SOUTH) %>% 
  count()

#====================================
#  10. summarise_each() function
#====================================

df11 %>% summarise_each(funs(min, max, sd), WAGE)

df11 %>% summarise_each(funs(min, max, sd), WAGE, AGE)

df11 %>% 
  group_by(MALE) %>% 
  summarise_each(funs(min, max, sd, mean),  WAGE)

df11 %>% 
  group_by(MALE) %>% 
  summarise_each(funs(min, max, sd, mean, n()),  WAGE)


#========================================
#     Data Visualization Section
#     1. Scatet Plot 
#     2. Line Plot
#     3. Bar Plot
#     4. Box Plot / Histogram / Density
#========================================

#----------------------------------------
#         1. Scatter Plot
#----------------------------------------

library(mosaic)
data("Galton")

# ?Galton

# A simple scatter plot (method 1): 
library(ggthemes)

Galton %>% 
  ggplot(aes(x = father, y = height)) + 
  geom_point() 



# Method 2: 

Galton %>% 
  ggplot(aes(father, height)) + 
  geom_point() + 
  geom_smooth(method = "lm")

Galton %>% lm(height ~ father, data = .) %>% summary()

# Add regression line: 

Galton %>% 
  ggplot(aes(father, height)) + 
  geom_point() + 
  geom_smooth(method = "lm")



p1 <- Galton %>% 
  ggplot(aes(father, height)) + 
  geom_point()

p1

p2 <- p1 + geom_smooth(method = "lm")

p2

p3 <- p1 + geom_smooth(method = "lm", se = FALSE)
p3

u <- Galton %>% 
  ggplot(aes(father, height)) + 
  geom_point(color = "blue", alpha = 0.4) + 
  geom_smooth(method = "lm", color = "red", fill = "purple")

u


Galton %>% 
  ggplot(aes(father, height)) + 
  geom_point(color = "#8B2323", alpha = 0.4) + 
  geom_point(data = Galton %>% filter(height > 75), color = "red", size = 4) + 
  geom_point(data = Galton %>% filter(height < 60), color = "yellow", size = 4) + 
  geom_smooth(method = "lm", color = "red", fill = "red") + 
  theme_minimal() + 
  labs(x = "Father's Height", y = "Son's Height", 
       title = "The Relationship between X and Y", 
       caption = "Data Source: F. Galton", 
       subtitle = "Unit: Inches")
  




Galton %>% 
  ggplot(aes(father, height)) + 
  geom_point(alpha = 0.3) + 
  geom_point(data = Galton %>% filter(height > 75), color = "red", size = 4) + 
  geom_point(data = Galton %>% filter(height < 60), color = "green", size = 4) + 
  geom_smooth(method = "lm")


theme_set(theme_minimal())

Galton %>% ggplot(aes(father, height, color = sex)) + 
  geom_point() + 
  geom_smooth(method = "lm")


Galton %>% 
  ggplot(aes(father, height, color = sex)) + 
  geom_point() + 
  geom_smooth(method = "lm", color = "blue", fill = "blue") + 
  facet_wrap(~ sex)

Galton %>% 
  ggplot(aes(father, height, color = sex)) + 
  geom_point() + 
  geom_smooth(method = "lm", color = "#8B1A1A",  fill = "purple", alpha = 0.2) +  
  facet_wrap(~ sex)




# A case Study: http://rpubs.com/chidungkt/271482 : 


# Load các gói và lấy dữ liệu  từ World Bank: 
# library(WDI)
# library(ggrepel)
# 
# mydf <- WDI(country = "all",
#             start = 2015,
#             end = 2016,
#             indicator = c("SP.POP.TOTL",
#                           # Tuổi thọ bình quân:
#                           "SP.DYN.LE00.IN",
#                           # GDP đầu người:
#                           "NY.GDP.PCAP.PP.CD"))
# write.csv(mydf, "E:/ngay_13_01.csv", row.names = FALSE)
# write.csv(d2, "E:/d2.csv", row.names = FALSE)
# 
# d <- WDIcache()
# 
# d2 <- data.frame(d[[2]])
# str(d2)
# # Chỉ lấy dữ liệu  năm 2015:

mydf <- read.csv("E:/ngay_13_01.csv")
d2 <- read.csv("E:/d2.csv")

nam2015 <- mydf %>% filter(year == 2015)
nam2015 %>% str()
d2 %>% str()


nam2015 <- nam2015 %>% mutate_if(is.factor, as.character)
nam2015 %>% str()

d2 <- d2 %>% mutate_if(is.factor, as.character)

# Lấy thêm một cột  biến  về  nhóm thu nhập cho các quốc gia: 
chung <- intersect(d2$country, nam2015$country)
chung %>% head()

nam2015 <- nam2015 %>% 
  filter(country %in% chung)

d2_small <- d2 %>% filter(country %in% chung)

nam2015 %>% names()
d2_small %>% names()

nam2015 <- merge(nam2015, d2_small, by = "country")

nam2015$income %>% table()


# Không lấy các quốc gia không  rõ nhóm thu nhập (loại Aggregates): 
nam2015 <- nam2015 %>% 
  filter(income != "Aggregates")

#   Hiển thị một  số quốc gia được  lựa  chọn: 
note <- c("Vietnam", "China", "India", "Japan", "Thailand", "Philippines", 
          "United States", "Indonesia", "Malaysia", "France", "Ukraine", 
          "Singapore", "Spain", "Australia", "Russian Federation")

# Mối quan hệ giữa thu nhập  đầu người (trục X) và tuổi thọ (trục Y) đồng thời
# biểu diễn quy  mô dân số của từng quốc gia bằng diện tích của đường tròn:


nam2015 %>% 
  ggplot(aes(NY.GDP.PCAP.PP.CD, SP.DYN.LE00.IN, size = SP.POP.TOTL, color = income)) + 
  geom_point()


library(ggrepel)

p <- nam2015 %>% ggplot(aes(NY.GDP.PCAP.PP.CD, SP.DYN.LE00.IN, size = SP.POP.TOTL, colour = income)) + 
  geom_point(alpha = 0.45, show.legend = FALSE) + 
  scale_size(range = c(1, 20)) + 
  scale_x_continuous(limits = c(500, 60000), 
                     breaks = seq(5000, 60000, by = 5000)) +  
  geom_text_repel(size = 3, aes(label = country), 
                  data = filter(nam2015, country %in% note), 
                  colour = "black", 
                  force = 10) + 
  labs(x = "GDP per capital", 
       y = "Life expectancy", 
       title = "The relationship between Life Expectancy and GDP per capital", 
       caption =  "Data Source: The World Bank")

p + theme_economist()


#----------------------------------------
#         2.  Bar Plot
#----------------------------------------

library(AER)
data("CPS1988")

k1 <- CPS1988 %>% 
  group_by(region) %>% count() %>% 
  ggplot(aes(region, n)) + geom_col() + theme_minimal()
k1


k2 <- CPS1988 %>% 
  group_by(region) %>% count() %>% 
  ggplot(aes(region, n, fill = region)) + 
  geom_col() + theme_minimal()
k2


k3 <- CPS1988 %>% 
  group_by(region) %>% count() %>% 
  ggplot(aes(reorder(region, n), n, fill = region)) + 
  geom_col(show.legend = FALSE)
k3


k4 <- k3 + coord_flip() + 
  labs(x = NULL, y = NULL, 
       title = "Observations by Region", 
       caption = "Data Source: US Census Bureau")
k4


k5 <- k4 + theme_economist(horizontal = FALSE)
k5

#  Nếu  muốn hiện  thêm số: 
k7 <- k4 + geom_text(aes(label = n), color = "white", hjust = 1.2)
k7

k8 <- CPS1988 %>% group_by(region, ethnicity) %>% count() %>% 
  ggplot(aes(region, n)) + geom_col() + 
  facet_wrap(~ ethnicity, scales = "free") + 
  geom_text(aes(label = n), color = "white", vjust = 1.2, size = 3) + 
  labs(x = NULL, y = NULL, 
       title = "Observations by Region and Ethnicity", 
       caption = "Data Source: US Census Bureau")

k8


k9 <- CPS1988 %>% group_by(region, ethnicity) %>% count() %>% 
  ggplot(aes(region, n, fill = ethnicity)) + geom_col(position = "stack") + 
  geom_text(aes(label = n), color = "white", vjust = 1.2, size = 3) + 
  labs(x = NULL, y = NULL, 
       title = "Observations by Region and Ethnicity", 
       caption = "Data Source: US Census Bureau")
k9
# Kiểu 3 (hiển thị hình): 
k10 <- CPS1988 %>% group_by(region, ethnicity) %>% count() %>% 
  ggplot(aes(region, n, fill = ethnicity)) + geom_col(position = "stack") + 
  labs(x = NULL, y = NULL, 
       title = "Observations by Region and Ethnicity", 
       caption = "Data Source: US Census Bureau")
k10


k11 <- CPS1988 %>% group_by(region, ethnicity) %>% count() %>% 
  ggplot(aes(region, n, fill = ethnicity)) + geom_col(position = "fill") + 
  labs(x = NULL, y = NULL, 
       title = "Observations by Region and Ethnicity", 
       caption = "Data Source: US Census Bureau")
k11


library(hrbrthemes)
k12 <- k11 + coord_flip() + scale_y_percent() + 
  labs(x = "US Region", y = "Ethnic Proportion", 
       title = "Observations by Region and Ethnicity", 
       caption = "Data Source: US Census Bureau")

k12






