CREATE TABLE [adw].[Member_Practice_History] (
    [URN]       INT           IDENTITY (1, 1) NOT NULL,
    [MBI]       VARCHAR (50)  NULL,
    [HICN]      VARCHAR (50)  NULL,
    [FirstName] VARCHAR (50)  NULL,
    [LastName]  VARCHAR (50)  NULL,
    [Sex]       VARCHAR (5)   NULL,
    [DOB]       DATE          NULL,
    [DOD]       DATE          NULL,
    [TIN]       VARCHAR (25)  NULL,
    [TIN_NAME]  VARCHAR (100) NULL,
    [PCSVS]     INT           NULL,
    [MBR_YEAR]  INT           NULL,
    [MBR_QTR]   INT           NULL,
    [LOAD_DATE] DATE          NULL,
    [LOAD_USER] VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);

