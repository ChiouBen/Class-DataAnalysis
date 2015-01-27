###專題題目: 
Blockbuster -Application of Random Forests and Regression Model for Opening Weekend Gross Forecasting
###專題目的:
利用過去電影之票房與其相關資訊，預測未來上映電影之首周票房，並期望將此預測資訊提供給電影院業者，使業者在安排播映場次上可達到最佳化。
###專題流程:
在資料收集方面，使用[Python]爬取IMDB網頁上2000至2014年電影相關資訊，並以製作成本高於10萬美金作為篩選條件，以篩選出美國獨立電影。並參考相關文獻以及利用視覺化工具挑選出影響票房之屬性，在[SQL server]中建立正規化表格存取資料。
    在資料ETL方面，利用[sqoop]將資料從[SQL server]存進hdfs上，使用Hive利用過去電影票房資訊，計算出各個屬性之權重並建立相關表格，在此權重為[0,1]間的數字，所採用的屬性有演員過去票房成績、導演過去票房成績、上映月份、電影類型、電影成本、上映廳院數量、有幾位有名的演員等7個屬性。
    在資料分析方面，首先使用主成分分析進行縮減維度，接著利用訓練資料建立隨機森林分類器，將電影分類在6個票房區間，在分別以每個區間裡的資料建立迴歸模型預測之後上映電影之首週票房，最後藉由同天上映之電影預測結果，建議業者如何安排播映場次。
