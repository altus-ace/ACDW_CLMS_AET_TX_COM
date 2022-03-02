CREATE TABLE [adw].[tmp_MembersWithClaims_CL] (
    [urn]          INT          IDENTITY (1, 1) NOT NULL,
    [SubscriberId] VARCHAR (50) NOT NULL,
    [CntOfClaims]  INT          NULL,
    [CreateDate]   DATETIME     CONSTRAINT [DF_tmp_MembersWithClaims_CL_CreateDate] DEFAULT (sysdatetime()) NOT NULL,
    [CreateBy]     VARCHAR (50) CONSTRAINT [DF_tmp_MembersWithClaims_CL_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);

