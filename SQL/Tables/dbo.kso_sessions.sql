CREATE TABLE [dbo].[kso_sessions] (
  [wpid] [int] NOT NULL,
  [json_data] [varchar](4000) NOT NULL,
  [updated] [datetime] NOT NULL DEFAULT (getdate()),
  CONSTRAINT [PK_kso_sessions_wpid] PRIMARY KEY CLUSTERED ([wpid])
)
ON [PRIMARY]
GO