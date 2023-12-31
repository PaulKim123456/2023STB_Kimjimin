#실습에필요한packages를등록
library(dplyr)
library(ggplot2)

#CSV형식의파일불러와서subway객체에입력하고구조확인
str(congestion)

#변수의이상치와결측치확인하고처리
summary(congestion)

#결측치개수확인
is.na(congestion)
sum(is.na(congestion))
colSums(is.na(congestion))

#결측치가있는행을제거한새로운데이터프레임생성
#6시 출발기차의결측치를제거
congestion1 <-congestion[!is.na(congestion$s0600),]
colSums(is.na(congestion1))

#23시30분출발기차의결측치를제거
congestion1 <-congestion1[!is.na(congestion1$s2330),]
colSums(is.na(congestion1))

#남은결측치를0으로대체
congestion1[is.na(congestion1)] <-0
colSums(is.na(congestion1))

#이상치확인
ggplot(congestion1, aes(y=s0530))+  
  geom_boxplot()

summary(congestion1$s0530)

#세부과제 2 시작
#1.지하철역의하루평균혼잡도
congestion1$day_mean <-rowMeans(congestion1[,c('s0530','s0600','s0630','s0700','s0730','s0800','s0830','s0900','s0930','s1000','s1030','s1100','s1130','s1200','s1230','s1300','s1330','s1400','s1430','s1500','s1530','s1600','s1630','s1700','s1730','s1800','s1830','s1900','s1930','s2000','s2030','s2100','s2130','s2200','s2230','s2300','s2330','s0000','s0030')])

#3.08시 지하철 혼잡도 범주화/범주별 빈도분석
congestion1 %>%
  mutate(s80_grade=ifelse(s0800<=80, "good", ifelse(s0800<=130, "normal", ifelse(s0800<=150, "caution",
                                                                                 "bad"))))%>%
  group_by(s80_grade) %>%
  summarise(n=n())%>%
  mutate(total=sum(n), pct=round(n/total*100,1))%>%
  select(s80_grade,n,pct)%>%
  arrange(desc(n))

#3-1. 호선별로 08시 지하철 혼잡도 범주화
congestion1 %>%
  mutate(s80_grade=ifelse(s0800<=80, "good", ifelse(s0800<=130, "normal", ifelse(s0800<=150, "caution",
                                                                                 "bad"))))%>%
  group_by(line, s80_grade) %>%
  summarise(n=n())%>%
  mutate(total=sum(n), pct=round(n/total*100,1))%>%
  filter(s80_grade=="caution")%>%
  select(line, s80_grade,n,pct)%>%
  arrange(desc(pct))%>%
  head(5)
