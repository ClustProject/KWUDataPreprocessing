function rstRRI = preprocessRRIs(RRIs)

N=length(RRIs);
win_ln = 100;
len = 0;
ratio = 0.65;

% Moving windows and 
for i =1: floor(N/win_ln)
   tmp = RRIs((i-1) * win_ln + 1 : i * win_ln);
   % fill outliers using Linear interpolation of non-outlier entries. 
   procTmp = filloutliers(tmp, 'linear');
   tmp_ln = length(procTmp);
   procRRIs(len+1: tmp_ln + len) = procTmp;   
   len = len + tmp_ln;
end

% Remove abnormal amplitudes based on median of data and predefined
% threshold
procRRIs(find((procRRIs < median(procRRIs)*ratio )))=[];

rstRRI = filloutliers(procRRIs, 'linear');

end
