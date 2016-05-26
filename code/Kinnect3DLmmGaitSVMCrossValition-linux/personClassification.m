function [ result ] = personClassification( labels )
maxSubjectId = max(labels(:,2));
for (i=1:maxSubjectId)
    result(i,1) = i;
    
    %if the subject is normal the mean will be 0 if is parkinson will be 1
    result(i,2) = mean(labels(labels(:,2) == i,1));
    

    
    solution = labels(labels(:,2) == i,1)
    classification = labels(labels(:,2) == i,4)
    cyclesCount = size(classification,1);
    
    if (sum(classification) < size(classification,1)/2) %Test the non-classification
        result(i,3) = 0;
    elseif (sum(classification) > size(classification,1)/2)
        result(i,3) = 1;
    else
        result(i,3) = 0;
    end% e
    
    solution = 0;
    classification = 0;
    %testSolutionClassification = labels(labels(:,3) == 1,1);
end


end

