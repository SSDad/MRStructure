function [DC] = fun_calDC(BW1, BW2)

junkAnd = BW1 & BW2;
junkAndSum = sum(junkAnd(:));
junk1 = sum(BW1(:));
junk2 = sum(BW2(:));
DC = 2*junkAndSum/(junk1 + junk2);
