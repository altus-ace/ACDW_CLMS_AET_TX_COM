CREATE TABLE [dbo].[tmp_QM_Mapping] (
    [tmpQMID]         INT           IDENTITY (1, 1) NOT NULL,
    [QM]              VARCHAR (20)  NULL,
    [QM_DESC]         VARCHAR (400) NULL,
    [CreatedBy]       VARCHAR (50)  NULL,
    [CreatedDateTime] DATETIME      NULL,
    [LastUpdatedBy]   VARCHAR (50)  NULL,
    [LastUpdatedDate] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([tmpQMID] ASC)
);

