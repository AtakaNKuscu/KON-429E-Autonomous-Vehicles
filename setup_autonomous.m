function setup_autonomous(section)
%SETUP_AUTONOMOUS Select hw1, hw2 or hw3 and configure MATLAB search paths.
% Example: setup_autonomous('hw1'); parameters; sample_input;
    arguments
        section (1,:) char {mustBeMember(section, {'hw1', 'hw2', 'hw3'})}
    end

    repoRoot = fileparts(mfilename('fullpath'));
    addpath(repoRoot);
    assignmentNumber = str2double(section(end));
    sectionRoot = fullfile(repoRoot, 'assignments', ...
        sprintf('assignment-%02d', assignmentNumber));
    folders = {'src', 'models', 'data'};
    for i = 1:numel(folders)
        folder = fullfile(sectionRoot, folders{i});
        if isfolder(folder)
            addpath(folder);
        end
    end
    cd(sectionRoot);
    fprintf('Working folder: %s\nSee README.md for simulation order.\n', sectionRoot);
end
