CREATE TABLE [adw].[Assignable_Member_History] (
    [URN]       INT           IDENTITY (1, 1) NOT NULL,
    [MBI]       VARCHAR (50)  NULL,
    [HICN]      VARCHAR (50)  NULL,
    [Plan]      VARCHAR (50)  NULL,
    [SubPlan]   VARCHAR (100) NULL,
    [Fname]     VARCHAR (50)  NULL,
    [Lname]     VARCHAR (50)  NULL,
    [Sex]       VARCHAR (50)  NULL,
    [DOB]       VARCHAR (50)  NULL,
    [DOD]       VARCHAR (50)  NULL,
    [CM_Flg]    VARCHAR (50)  NULL,
    [Mbr_Type]  VARCHAR (50)  NULL,
    [MBR_YEAR]  INT           NULL,
    [MBR_QTR]   INT           NULL,
    [LOAD_DATE] DATE          DEFAULT (sysdatetime()) NULL,
    [LOAD_USER] VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);

