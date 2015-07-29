function [] = print_mrs_to_latex_table( mrsSpec, param_format, print_tab_env)
    %PRINT_MRS_TO_LATEX_TABLE Print Markov regime-swithcing specification obtained from MS_Regress library (Perlin M., 2012) into LaTeX table
    %
    %   Copyright (c) 2014 by Dmitriy O. Afanasyev
    %   Versions:
    %       1.0 2014.09.15: initial version
    %
    
    if(nargin < 2)
        param_format = '%4.4f';
    end
    if(nargin < 3)
        print_tab_env = 1;
    end
    
    nr=size(mrsSpec.condMean, 1);
    nEq = size(mrsSpec.S, 1);
    S = mrsSpec.S;
    distrib = mrsSpec.advOpt.distrib;
    k = mrsSpec.k;
    param = mrsSpec.param;
    P = mrsSpec.Coeff.p;
    stateDur = mrsSpec.stateDur;
    diagCovMat = mrsSpec.advOpt.diagCovMat;
    
    n_indep=cell(nEq);
    n_S=cell(nEq);
    n_nS=cell(nEq);
    count=cell(nEq);
    countS=cell(nEq);
    
    S_S=cell(nEq);
    %     indep_S=cell(nEq);
    S_nS=cell(nEq);
    %     indep_nS=cell(nEq);
    
    for iEq=1:nEq
        switch distrib
            case 'Normal'
                n_dist_param=   1; % Number of distributional parameters
                S_Var{iEq}=S{iEq}(end);     % if model switches in variance
                S_df{iEq}=0;                % flag for S_df (keep for simplicity of algorithm)
                S_K{iEq}=0;                 % flag for S_K (keep for simplicity of algorithm)
            case 't'
                S_Var{iEq}=S{iEq}(end-1);   % if model switches in variance
                S_df{iEq}=S{iEq}(end);      % if model is switching in degrees of freedom
                S_K{iEq}=0;
                n_dist_param=2; % Number of distributional parameters
            case 'GED'
                S_Var{iEq}=S{iEq}(end-1);
                S_K{iEq}=S{iEq}(end);     % if model is switching in K parameter (K as the GED parameter)
                S_df{iEq}=0;
                n_dist_param=2; % Number of distributional parameters
            case 'GED2'
                S_Var{iEq}=S{iEq}(end-1);
                S_K{iEq}=S{iEq}(end);     % if model is switching in K parameter (K as the GED2 parameter)
                S_df{iEq}=0;
                n_dist_param=2; % Number of distributional parameters
        end
        
        n_indep{iEq}=size(S{iEq},2) - n_dist_param;
        n_S{iEq}=sum(S{iEq}(1:end-n_dist_param));
        n_nS{iEq}=n_indep{iEq}-n_S{iEq};
        count{iEq}=0;
        countS{iEq}=0;
        
        % Checking which parameters will have switching effect
        
        S_S{iEq}=zeros(1,n_S{iEq});
        S_nS{iEq}=zeros(1,n_nS{iEq});
        
        for i=1:(length(S{iEq})-n_dist_param)
            if S{iEq}(i)==1
                countS{iEq}=countS{iEq}+1;
                S_S{iEq}(countS{iEq})=i;
                %                 indep_S{iEq}(:,countS{iEq})=indep{iEq}(:,i);
            else
                count{iEq}=count{iEq}+1;
                S_nS{iEq}(count{iEq})=i;
                %                 indep_nS{iEq}(:,count{iEq})=indep{iEq}(:,i);
            end
        end
    end
    
    if(print_tab_env)
        colAlign = 'l';
        for i=1:k
            colAlign = [colAlign 'r'];
        end
        
        fprintf(1, '\\begin{table*}[!h]\n');
        fprintf(1, '\\caption{}\n');
        fprintf(1, '\\label{tab:}\n');
        fprintf(1, '\\setlength{\\arrayrulewidth}{1.05 pt}\n');
        fprintf(1, '\\renewcommand{\\arraystretch}{1.1}\n');
        fprintf(1, ['\\begin{tabular*}{1.0\\textwidth}{@{\\extracolsep{\\fill}}' colAlign '}\n']);
        fprintf(1, '\\hline\n');
        fprintf(1, 'Regime ');
        for j=1:k
            fprintf(1, ['& ' num2str(j) ' ']);
        end
        fprintf(1, '\\\\\n');
        fprintf(1, '\\hline\n');
    end
    
    for iEq=1:nEq
        if(nEq > 1)
            fprintf(1, ['& \\multicolumn{' num2str(k) '}{c}{\\textit{Equation #' num2str(iEq) ' }}\\\\\n']);
        end
        
        % Switching Parameters (Regressors)
        if n_S{iEq}~=0
            for i=1:n_S{iEq}
                fprintf(1, ['$\\beta_' num2str(S_S{iEq}(i)-1) '$ ']);
                for j=1:k
                    fprintf(1, ['& ' model_param_to_latex(mrsSpec.Coeff.S_Param{iEq}(i,j), ...
                        mrsSpec.Coeff_SE.S_Param{iEq}(i,j), ...
                        2*(1-tcdf(abs(mrsSpec.Coeff.S_Param{iEq}(i,j))/mrsSpec.Coeff_SE.S_Param{iEq}(i,j),nr-numel(param))), ...
                        param_format)]);
                end
                fprintf(1, '\\\\\n');
            end
        end
        
        if S_Var{iEq}
            fprintf(1, '$\\sigma^2$ ');
            for j=1:k
                fprintf(1, ['& ' model_param_to_latex(mrsSpec.Coeff.covMat{j}(iEq,iEq), ...
                    mrsSpec.Coeff_SE.covMat{j}(iEq,iEq), ...
                    2*(1-tcdf(abs(mrsSpec.Coeff.covMat{j}(iEq,iEq)/mrsSpec.Coeff_SE.covMat{j}(iEq,iEq)),nr-numel(param))), ...
                    '%.1e')]);
            end
            fprintf(1, '\\\\\n');
        end
        
        if S_df{iEq}
            fprintf(1, '$dF$ ');
            for j=1:k
                fprintf(1, ['& ' model_param_to_latex(mrsSpec.Coeff.df{iEq}(1,j), ...
                    mrsSpec.Coeff_SE.df{iEq}(1,j), ...
                    2*(1-tcdf(abs(mrsSpec.Coeff.df{iEq}(1,j))/mrsSpec.Coeff_SE.df{iEq}(1,j),nr-numel(param))), ...
                    param_format)]);
            end
            fprintf(1, '\\\\\n');
        end
        
        if S_K{iEq}
            fprintf(1, '$K$ ');
            for j=1:k
                fprintf(1, ['& ' model_param_to_latex(mrsSpec.Coeff.K{iEq}(j), ...
                    mrsSpec.Coeff_SE.K{iEq}(j), ...
                    2*(1-tcdf(abs(mrsSpec.Coeff.K{iEq}(j))/mrsSpec.Coeff_SE.K{iEq}(j),nr-numel(param))), ...
                    param_format)]);
            end
            fprintf(1, '\\\\\n');
        end
    end
    
    %Probabilities
    pValue_P=2*(1-tcdf(abs(mrsSpec.Coeff.p)./mrsSpec.Coeff_SE.p,nr-numel(param)));
    fprintf(1, '$p_{ss}$ ');
    for i=1:k
        fprintf(1, ['& ' model_param_to_latex(P(i,i), mrsSpec.Coeff_SE.p(i,i), pValue_P(i,i), '%4.2f')]);
    end
    fprintf(1, '\\\\\n');
    
    %Durations
    fprintf(1, '$T_s$ ');
    for i=1:k
        fprintf(1, ['& ' num2str(stateDur(i), '%4.2f') ' ']);
    end
    fprintf(1, '\\\\\n');
    
    %
    %         fprintf(1,'\n---> Non Switching Parameters <---\n');
    %
    %         if (n_nS{iEq}==0)&&(any([S_Var{iEq},S_df{iEq},S_K{iEq}])==0)
    %             fprintf(1,'\nThere was no Non Switching Parameters for Indep matrix of Equation #%i. Skipping this result',iEq);
    %         else
    %             for i=1:n_nS{iEq}
    %                 fprintf(1,'\nNon Switching Parameter for Equation #%i, Indep column %i ',iEq, S_nS{iEq}(i));
    %                 fprintf(1,['\n     Value:                ', num2str(mrsSpec.Coeff.nS_Param{iEq}(i),'%4.4f')]);
    %                 fprintf(1,['\n     Std Error (p. value): ', num2str(mrsSpec.Coeff_SE.nS_Param{iEq}(i),'%4.4f'), ...
    %                     ' (',num2str(2*(1-tcdf(abs(mrsSpec.Coeff.nS_Param{iEq}(i))/mrsSpec.Coeff_SE.nS_Param{iEq}(i),nr-numel(param))),'%4.2f'),')']);
    %
    %             end
    %         end
    %
    %         if S_Var{iEq}==0
    %             fprintf(1,'\n\nNon Switching Variance of model ');
    %             fprintf(1,['\n     Value:                ', num2str(mrsSpec.Coeff.covMat{1}(iEq,iEq),'%4.6f')]);
    %             fprintf(1,['\n     Std Error (p. value): ', num2str(mrsSpec.Coeff_SE.covMat{1}(iEq,iEq),'%4.4f'), ...
    %                 ' (',num2str(2*(1-tcdf(abs(mrsSpec.Coeff.covMat{1}(iEq,iEq))/mrsSpec.Coeff_SE.covMat{1}(iEq,iEq),nr-numel(param))),'%4.2f'),')']);
    %         end
    %
    %         switch distrib
    %             case 't'
    %
    %                 if S_df{iEq}==0
    %
    %                     fprintf(1,'\nNon Switching Degrees of Freedom (t distribution)');
    %                     fprintf(1,['\n     Value:                ', num2str(mrsSpec.Coeff.df{iEq}(1),'%4.4f')]);
    %                     fprintf(1,['\n     Std Error (p. value): ', num2str(mrsSpec.Coeff_SE.df{iEq}(1),'%4.4f') , ...
    %                         ' (',num2str(2*(1-tcdf(abs(mrsSpec.Coeff.df{iEq}(1))/mrsSpec.Coeff_SE.df{iEq}(1),nr-numel(param))),'%4.2f'),')']);
    %                 end
    %
    %             case 'GED'
    %
    %                 if S_K{iEq}==0
    %                     fprintf(1,'\nNon Switching k parameter (GED distribution)');
    %                     fprintf(1,['\n     Value of k:                 ', num2str(mrsSpec.Coeff.K{iEq}(1),'%4.4f')]);
    %                     fprintf(1,['\n     Std Error (p. value):       ', num2str(mrsSpec.Coeff_SE.K{iEq}(1),'%4.4f') , ...
    %                         ' (',num2str(2*(1-tcdf(abs(mrsSpec.Coeff.K{iEq}(1))/mrsSpec.Coeff_SE.K{iEq}(1),nr-numel(param))),'%4.2f'),')']);
    %                 end
    %
    %             case 'GED2'
    %
    %                 if S_K{iEq}==0
    %                     fprintf(1,'\nNon Switching k parameter (GED ver.2 distribution)');
    %                     fprintf(1,['\n     Value of k:                 ', num2str(mrsSpec.Coeff.K{iEq}(1),'%4.4f')]);
    %                     fprintf(1,['\n     Std Error (p. value):       ', num2str(mrsSpec.Coeff_SE.K{iEq}(1),'%4.4f') , ...
    %                         ' (',num2str(2*(1-tcdf(abs(mrsSpec.Coeff.K{iEq}(1))/mrsSpec.Coeff_SE.K{iEq}(1),nr-numel(param))),'%4.2f'),')']);
    %                 end
    %         end
    
    %     if ~diagCovMat
    %
    %         fprintf(1,'\n\n---> Covariance Matrix <---\n');
    %         for ik=1:k
    %             fprintf(1,['\nState ', num2str(ik)]);
    %             pValue_covMat=2*(1-tcdf(abs(mrsSpec.Coeff.covMat{ik})./mrsSpec.Coeff_SE.covMat{ik},nr-numel(param)));
    %
    %             for iEq=1:nEq
    %                 fprintf(1,'\n      ');
    %                 for jEq=1:nEq
    %                     fprintf(1,'%4.5f (%4.5f,%4.2f)   ',mrsSpec.Coeff.covMat{ik}(iEq,jEq),mrsSpec.Coeff_SE.covMat{ik}(iEq,jEq),pValue_covMat(iEq,jEq));
    %                 end
    %             end
    %         end
    %     end
    
    if(print_tab_env)
        fprintf(1, '\\hline\n');
        fprintf(1, '\\end{tabular*}\n');
        fprintf(1, '\\begin{spacing}{0.5}\n');
        fprintf(1, '{\\scriptsize }\n');
        fprintf(1, '\\end{spacing}\n');
        fprintf(1, '\\end{table*}\n');
    end
end