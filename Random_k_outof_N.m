function [B_dam]=Random_k_outof_N(B_undamaged,From_Node,To_Node,k)
     %restore the network undamaged configuration
    B_dam=B_undamaged; 
    % random attack of k line in the network
     FailedLinesIdx=randperm(length(From_Node),k);
    for i=1:k
    B_dam(From_Node(FailedLinesIdx(i)),To_Node(FailedLinesIdx(i)))=0; %no NO NO N ON O NO NO N O NO N ON ON O NO NO N
    B_dam(To_Node(FailedLinesIdx(i)),From_Node(FailedLinesIdx(i)))=0; 
    end
end