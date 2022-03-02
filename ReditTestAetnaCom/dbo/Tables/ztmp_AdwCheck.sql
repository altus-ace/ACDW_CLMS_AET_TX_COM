CREATE TABLE [dbo].[ztmp_AdwCheck] (
    [URN]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [CheckEntity]     VARCHAR (50)  NULL,
    [CheckDesc]       VARCHAR (100) NULL,
    [Active]          VARCHAR (1)   NULL,
    [Catalog]         VARCHAR (50)  NULL,
    [Schema]          VARCHAR (50)  NULL,
    [Table]           VARCHAR (50)  NULL,
    [S_Fields]        VARCHAR (150) NULL,
    [S_GroupBy]       VARCHAR (100) NULL,
    [S_Where]         VARCHAR (100) NULL,
    [S_Having]        VARCHAR (100) NULL,
    [S_ResultRecords] INT           NULL,
    [S_TotalRecords]  INT           NULL,
    [Notes]           VARCHAR (200) NULL,
    [RunDate]         DATETIME      NOT NULL,
    [RunBy]           VARCHAR (50)  NOT NULL,
    [RunDuration]     INT           NULL,
    CONSTRAINT [PK_Claims_Diags] PRIMARY KEY CLUSTERED ([URN] ASC)
);

