defmodule MedHub.Repo.Migrations.AddMedicsNumberToWorkplaces do
  use Ecto.Migration

  def up do
    alter table(:workplaces) do
      add :medics_count, :integer, default: 0, null: false
    end

    create_trigger_insert_fun()
    create_trigger_update_fun()
    create_triggers()

    create constraint(:workplaces, :check_medics_count, check: "medics_count <= 50")
  end

  def down do
    execute("DROP TRIGGER IF EXISTS increment_medics_count ON medics")
    execute("DROP TRIGGER IF EXISTS decrement_medics_count ON medics")
    execute("DROP TRIGGER IF EXISTS check_medic_update ON medics")
    execute("DROP FUNCTION IF EXISTS update_medics_count")
    execute("DROP FUNCTION IF EXISTS prevent_medic_update")

    alter table(:workplaces) do
      remove :medics_count
    end
  end

  defp create_trigger_insert_fun do
    ~s"""
    CREATE OR REPLACE FUNCTION update_medics_count() 
    RETURNS TRIGGER AS $$
    BEGIN
        -- Increment medics_count on insert
        IF TG_OP = 'INSERT' THEN
            UPDATE workplaces
            SET medics_count = medics_count + 1
            WHERE id = NEW.workplace_id;
        -- Decrement medics_count on delete
        ELSIF TG_OP = 'DELETE' THEN
            UPDATE workplaces
            SET medics_count = medics_count - 1
            WHERE id = OLD.workplace_id;
        END IF;
        RETURN NEW;
    END;
    $$ language plpgsql;
    """
    |> execute()
  end

  defp create_trigger_update_fun do
    ~s"""
    CREATE OR REPLACE FUNCTION prevent_medic_update() 
    RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'UPDATE' AND NEW.workplace_id != OLD.workplace_id) THEN
            -- Decrement count on the old workplace
            UPDATE workplaces
            SET medics_count = medics_count - 1
            WHERE id = OLD.workplace_id;
            -- Increment count on the new workplace
            UPDATE workplaces
            SET medics_count = medics_count + 1
            WHERE id = NEW.workplace_id;
            -- Ensure new workplace doesn't exceed limit
            IF (SELECT medics_count FROM workplaces WHERE id = NEW.workplace_id) > 50 THEN
                RAISE EXCEPTION 'Workplace cannot have more than 50 medics';
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$ language plpgsql;
    """
    |> execute()
  end

  defp create_triggers do
    ~s"""
    CREATE TRIGGER increment_medics_count
    AFTER INSERT ON medics
    FOR EACH ROW
    EXECUTE FUNCTION update_medics_count();
    """
    |> execute()

    ~s"""
    CREATE TRIGGER decrement_medics_count
    AFTER DELETE ON medics
    FOR EACH ROW
    EXECUTE FUNCTION update_medics_count();
    """
    |> execute()

    ~s"""
    CREATE TRIGGER check_medic_update
    BEFORE UPDATE ON medics
    FOR EACH ROW
    EXECUTE FUNCTION prevent_medic_update();
    """
    |> execute()
  end
end
