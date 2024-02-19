table 70025 "PTA Sync Status"
{
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; PK; code[20])
        {

        }
        field(2; isRunning; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Run DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Running in Company"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; PK)
        {
            Clustered = true;
        }
    }

    procedure GetStatus(): Boolean;
    begin
        exit(isRunning)
    end;

    Procedure InsertStatus(RunningInCompany: text[100])
    begin
        if not GET then begin
            Init();
            PK := '';
            isRunning := true;
            "Run DateTime" := CURRENTDATETIME;
            "Running in Company" := RunningInCompany;
            Insert(true);
        end else begin
            isRunning := true;
            "Run DateTime" := CURRENTDATETIME;
            "Running in Company" := RunningInCompany;
            Modify(true);
        end;
    end;

    procedure DeactivateStatus()
    begin
        isRunning := false;
        "Run DateTime" := 0DT;
        "Running in Company" := '';
        Modify(true);
    end;
}

