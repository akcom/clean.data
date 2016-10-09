library(data.table)
library(dplyr)
library(tidyr)

activities.fname <- '/Users/akcom/Projects/clean.data/UCI HAR Dataset/activity_labels.txt'

feats.fname <- '/Users/akcom/Projects/clean.data/UCI HAR Dataset/features.txt'

test.fname <- '/Users/akcom/Projects/clean.data/UCI HAR Dataset/test/X_test.txt'
train.fname <- '/Users/akcom/Projects/clean.data/UCI HAR Dataset/train/X_train.txt'

test.y.fname <- '/Users/akcom/Projects/clean.data/UCI HAR Dataset/test/y_test.txt'
train.y.fname <- '/Users/akcom/Projects/clean.data/UCI HAR Dataset/train/y_train.txt'

test.sub.fname <- '/Users/akcom/Projects/clean.data/UCI HAR Dataset/test/subject_test.txt'
train.sub.fname <- '/Users/akcom/Projects/clean.data/UCI HAR Dataset/train/subject_train.txt'

#get the subjects
df.sub <- rbind(read.table(test.sub.fname, col.names=c('subject')),
                read.table(train.sub.fname, col.names=c('subject')))

#get the test and train data, fix the seperators 
df.x <- rbind(read.table(textConnection(gsub("  ", " ", readLines(test.fname)))),
                   read.table(textConnection(gsub("  ", " ", readLines(train.fname)))))

#only use this once its been created
#write.table(df.x, '/Users/akcom/Projects/clean.data/UCI HAR Dataset/out.txt')
df.x <-read.table('/Users/akcom/Projects/clean.data/UCI HAR Dataset/out.txt')

#get the test and training labels
df.y <- rbind(read.table(test.y.fname, col.names=c('index')),
                   read.table(train.y.fname, col.names=c('index')))

#get the feature names
df.names <- read.table(feats.fname, sep=' ', stringsAsFactors = FALSE, col.names=c('index', 'name'))
#make em pretty
df.names$name <- gsub('\\(\\)|-', '', df.names$name)
#activity names
df.activities <- read.table(activities.fname, sep=' ', stringsAsFactors = FALSE, col.names=c('index', 'activity.name'))

#add the labels for the y
df.y <- df.y %>% inner_join(df.activities)

#combine test and train data
colnames(df.x) <- df.names$name
#keep the mean and std fields
keep.cols <- grepl('mean|std', colnames(df.x))
df.x <- df.x[,keep.cols]

#create the whole data set, X and y
df.all <- cbind(df.x, df.y, df.sub)

df.all <- read.table('/Users/akcom/Projects/clean.data/df.all.txt')
dt.all <- data.table(df.all)
#save the output
#write.table(df.all, '/Users/akcom/Projects/clean.data/df.all.txt')

names <- colnames(dt.all)
dt.long <- melt(dt.all,
                id.vars=seq(length(names)-2,length(names)),
                measure.vars=seq(1, length(names)-3))
#write.table(dt.long, '/Users/akcom/Projects/clean.data/dt.long.txt')

dt.sum <- dt.long[,.(avg=mean(value)), .(subject, name, )]
write.table(dt.sum, '/Users/akcom/Projects/clean.data/dt.sum.txt')
