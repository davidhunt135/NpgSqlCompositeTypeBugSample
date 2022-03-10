using Npgsql;

var connStringBuilder = new NpgsqlConnectionStringBuilder();
connStringBuilder.Host = "127.0.0.1";
connStringBuilder.Port = 5404;
connStringBuilder.Database = "npgsql_sample";
connStringBuilder.SearchPath = "sample1";
connStringBuilder.Username = "";
connStringBuilder.Password = "";

var connection = new NpgsqlConnection(connStringBuilder.ConnectionString);
connection.Open();


// Error happens with or without these 4 lines
// Without the error happen when trying to map sample1.composite_child[]
// With the error happens when trying to map sample1.composite 
connection.TypeMapper.MapComposite<CompositeType>("sample1.composite");
connection.TypeMapper.MapComposite<CompositeChildType>("sample1.composite_child");

// Doesn't affect results
// connection.TypeMapper.MapComposite<CompositeType>("sample2.composite");
// connection.TypeMapper.MapComposite<CompositeChildType>("sample2.composite_child");

using var command = new NpgsqlCommand("select * from composite_table;", connection);
using var reader = command.ExecuteReader();

while (reader.Read())
{
    Console.WriteLine(reader.GetInt64(0));
    Console.WriteLine(reader.GetFieldValue<CompositeType>(1));
}

class CompositeType
{
    public string Name { get; set; }
    public CompositeChildType Child { get; set; }
    
    // NOTE: This is the property which causes problems.
    // I have found that updating Npgsql/TypeMapping/ConnectorTypeMapper.cs lines 94, 418 and 571 to use pgType.DisplayName instead of pgType.Name for type lookup resolves the problem.
    // Whether this is an exhaustive list of required changes I'm not sure.
    public CompositeChildType[] ChildArray { get; set; }

    public override string ToString()
    {
        var childArray = string.Join(',', ChildArray.Select(x => x.Name));
        return Name + " " + Child.Name + "; child array: " + childArray;
    }
}

class CompositeChildType
{
    public string Name { get; set; }

    public override string ToString()
    {
        return Name;
    }
}