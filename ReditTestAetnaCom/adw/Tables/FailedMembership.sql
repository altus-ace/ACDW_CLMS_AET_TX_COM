﻿CREATE TABLE [adw].[FailedMembership] (
    [FailedMembershipKey] INT           IDENTITY (1, 1) NOT NULL,
    [CreateDate]          DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]     DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]       VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LoadDate]            DATE          NOT NULL,
    [DataDate]            DATE          NOT NULL,
    [ClientKey]           INT           NOT NULL,
    [EffectiveDate]       DATE          NOT NULL,
    [AdiKey]              INT           NOT NULL,
    [StagingKey]          INT           NOT NULL,
    [ClientMemberKey]     VARCHAR (50)  NOT NULL,
    [AceID]               NUMERIC (15)  NOT NULL,
    [NPI]                 VARCHAR (50)  NULL,
    [AttribTIN]           VARCHAR (50)  NULL,
    [PlanName]            VARCHAR (50)  NULL,
    [PlanID]              VARCHAR (50)  NULL,
    [MbrNPIFlg]           TINYINT       DEFAULT ((0)) NULL,
    [MbrPlnFlg]           TINYINT       DEFAULT ((0)) NULL,
    [MbrFlgCount]         TINYINT       DEFAULT ((0)) NULL,
    [Exported]            TINYINT       DEFAULT ((0)) NOT NULL,
    [ExportedDate]        DATE          DEFAULT ('1900-01-01') NULL,
    [NPIName]             VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([FailedMembershipKey] ASC)
);

