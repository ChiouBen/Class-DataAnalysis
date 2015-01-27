cast_table=function(queryResults2,queryResults4){

  cast_f=queryResults4$cast
  we=matrix(0,nrow=length(cast_f),ncol=13)
  colnames(we)=c('name',2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015)
  we[,1]=cast_f

  for(j in 1:12){
    for(i in 1:length(cast_f)){
      if(j==1){vector=gross[which(queryResults2$cast==we[i,1] & year<(2003+j))]}
      else{vector=gross[which(queryResults2$cast==we[i,1] & year==(2002+j))]}
      we[i,(1+j)]=round(mean(vector), 4)
    }
  }
#--------------------------------------------------
  for(i in 1:dim(we)[1]){
    m=which(we[i,2:13]=='NaN')
    n=which(we[i,2:13]!='NaN')
    if(min(n)!=1){we[i,2:min(n)]=rep(we[i,2:13][min(n)],(min(n)-1))}
    if(length(n)>1){
      for(r in 1:(length(n)-1)){
        if((n[r+1]-n[r])>1){
          we[i,2:13][(n[r]+1):(n[r+1]-1)]=rep(we[i,2:13][n[r]],(n[r+1]-n[r]-1))}
      }
    }
    if(max(n)!=12){
      we[i,2:13][(max(n)+1):12]=rep(we[i,2:13][max(n)],(12-max(n)))
    }
  }
  return(we)
}