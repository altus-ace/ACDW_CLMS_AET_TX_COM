CREATE TABLE [lst].[lstClientCodeLookup] (
    [ClientCodeLookupKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientKey]           INT           NOT NULL,
    [ClientCode]          VARCHAR (20)  NOT NULL,
    [ClientCodeDesc]      VARCHAR (50)  NOT NULL,
    [ClientCodeTypesKey]  INT           NOT NULL,
    [LoadDate]            DATE          CONSTRAINT [DF_lstClientCodeLookup_LoadDate] DEFAULT (getdate()) NOT NULL,
    [CreatedDate]         DATETIME2 (7) CONSTRAINT [DF_LstClientCodeLookup_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)  CONSTRAINT [DF_LstClientCodeLookup_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]     DATETIME2 (7) CONSTRAINT [DF_LstClientCodeLookup_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]       VARCHAR (50)  CONSTRAINT [DF_LstClientCodeLookup_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ClientCodeLookupKey] ASC),
    CONSTRAINT [FK_lstClientCodeLookup_TolstClientCodeTypes] FOREIGN KEY ([ClientCodeTypesKey]) REFERENCES [lst].[lstClientCodesTypes] ([ClientCodesTypeKey])
);

