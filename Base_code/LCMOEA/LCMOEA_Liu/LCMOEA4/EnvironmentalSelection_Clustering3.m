function [Population,z,znad] = EnvironmentalSelection_Clustering3(Population,N,z,znad,cSize,a)
%Clustering-based environmental selection without considering constraints

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    
    %% Non-dominated sorting
    remainSize = N; 
    %remainSize = floor((1.2-0.2*a)*N);
    [FrontNo,MaxFNo] = NDSort(Population.objs,remainSize);
    
    St = find(FrontNo<=MaxFNo);
    
    %% Normalization
    [PopObj,z,znad] = Normalization1(Population(St).objs,z,znad);
    %PopObj = Population(St).objs;
    normP = sum(PopObj,2);

    %% Consine Similarity-based Clustering
    [~,class] = clustering(PopObj,cSize); 
    
    %% Selection from each cluster
    for i = 1 : cSize
        C = find(class==i);
        if length(C) == 1
            next(i) = C(1);
        else
            minIndex = 1;
            for j = 2:length(C)
                if normP(C(j)) < normP(C(minIndex))
                    minIndex = j;
                end
            end
            next(i) = C(minIndex);
        end
    end
    %% Population for next generation
    Population = Population(St(next));
end

function [clusters, class] = clustering(PopObj,cSize)
    N  = size(PopObj,1);
    PopObj = PopObj./sum(PopObj,2);%Mapping to the unit hyperplane
    clusters = cell(1,N); %Initialize each solution as a cluster
    centroids = cell(1,N);
    for i = 1:N
        clusters{i} = PopObj(i,:);%the i-th solution is initialized as the i-th cluster
        centroids{i} = PopObj(i,:);%the i-th solution is initialized as the i-th centroid
        flag(i) = 0; %using a flag to indicate the clustering process
        class(i) = i;%the i-th solution belong to the i-th cluster
    end
    %mminD = pdist2(centroids{1}, centroids{2},"cosine");%record the two most similar clusters 
    %mminD = pdist2(centroids{1}, centroids{2});
    mminD = norm(centroids{1}-centroids{2});
    index2 = 1;
    index3 = 2;
    for i = 1:N
        rd = randi(N);
        while rd == i
            rd = randi(N);
        end
        minD = norm(centroids{i}-centroids{rd});
        index0 = i;
        index1 = rd;
        for j = 1:N
            if i ~= j
                dist = norm(centroids{i}-centroids{j});
                if minD > dist
                    minD = dist;
                    index0 = i;
                    index1 = j;
                end
            end
        end
        minDist(i) = minD;
        minIndex(i) = index1;
        if mminD > minD
            mminD = minD;
            index2 = index0;
            index3 = index1;
        end
    end
    nsize = N; %the initial size of cluster
    while nsize>cSize
        flag(index2) = 1;
        %Merge the currenct two most similar clusters, i.e., index2 and index3 
        clusters{index3} = [clusters{index3};clusters{index2}];
        %update the centroid of the combined cluster
        centroids{index3} = mean(clusters{index3},1);
        for i = 1:N %find the next most similar cluster-pair
            if(class(i) == index2) %the solutions belong to index2-cluster is combined into index3-cluster
                class(i) = index3;
            end
            if  flag(i) == 0 && (minIndex(i) == index3 || minIndex(i) == index2)
                rd = randi(N);
                while rd==i || flag(rd)==1
                    rd = randi(N);
                end
                minD = norm(centroids{i}-centroids{rd});
                for j = 1:N
                    if i~=j && flag(j) == 0
                        ss = norm(centroids{i}-centroids{j});
                        if minD > ss
                            minD = ss;
                            rd = j;
                        end
                    end
                end
                minIndex(i) = rd;
                minDist(i) = minD;
            end
        end
        rd = randi(N);
        while flag(rd)==1
            rd = randi(N);
        end
        fDist = minDist(rd);
        index2 = rd;
        index3 = minIndex(rd);
        for i = 1:N
            if flag(i) == 0
                if fDist > minDist(i)
                    fDist = minDist(i);
                    index2 = i;
                    index3 = minIndex(i);
                end
            end
        end
        nsize = nsize-1; 
    end

    %From N clusters to Cize Clusters
    for i = N:-1:1
        if flag(i) == 1 %Has been combined
            clusters{i} = []; 
            for j = N:-1:1
                if class(j) > i
                    class(j) = class(j)-1;
                end
            end
        end 
    end
    class = class';
end