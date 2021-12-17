function index =crossvalidation( data_num , cross)
    rand_index = randperm( data_num );
    
    index=cell(1,cross);
    for repeat=0:cross-1
        %学習サンプルと評価サンプルのindexを求める
        begin_index = floor(repeat*data_num/cross) + 1;
        end_index = floor( (repeat+1)*data_num/cross );
        test_index = rand_index(1, begin_index:end_index);
        train_index = setdiff(rand_index,test_index);
    
        index{repeat+1}.train=train_index;
        index{repeat+1}.test=test_index;
    end
    
end