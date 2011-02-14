# About CustomConfig plugin for Movable Type

## Synopsis

Create and manage system scope coutom configuration and you can register a custom MT tag on system level.
CustomConfig object has 'Name', 'Key' and 'Value'. To create and manage CustomConfig object(s), 'System Overview' &raquo; (menu)'Settings' &raquo; 'Custom Config'.

## Template Tags

---------------------------------------

**MTCustomConfigLoop(Block Tag)**

A container tag which iterates over a list of all of the CustomConfig objects in the system.

*Attributes*

    id         : Outputs a single CustomConfig object matching the given ID.
    name       : A name column of CustomConfig objects.
    key        : A key column of CustomConfig objects.
    value      : A value column of CustomConfig objects.
    priority   : A priority of CustomConfig objects.
    sort_by    : Defines the data to sort CustomConfig objects.
                 The default value is "priority".
    sort_order : Accepted values are "ascend" and "descend".
                 Default order is descend.
    lastn      : Display the N CustomConfig objects. N is a positive integer.
    offset     : Used in coordination with lastn,
                 starts N CustomConfig objects from the start of the list.

*Example:*

    <MTCustomConfigLoop key="foo" sort_by="priority" sort_order="descend">
        <$MTCustomConfigName$>
        <$MTCustomConfigValue$>
    </MTCustomConfigLoop>

---------------------------------------

**MTCustomConfig(Block Tag)**

A container tag which outputs a single CustomConfig object matching the attributes.

*Attributes*

    id         : Outputs a single CustomConfig object matching the given ID.
    name       : A name column of CustomConfig object.
    key        : A key column of CustomConfig object.
    value      : A value column of CustomConfig object.
    priority   : A priority of CustomConfig object.
    sort_by    : Defines the data to sort CustomConfig object.
                 The default value is "priority".
    sort_order : Accepted values are "ascend" and "descend".
                 Default order is descend.
    offset     : Used in coordination with lastn,
                 starts N CustomConfig objects from the start of the list.

*Example:*

    <MTCustomConfig name="foo">
        <$MTCustomConfigValue$>
    </MTCustomConfigLoop>

*Same as that.*

    <MTCustomConfigLoop name="foo" sort_by="priority" sort_order="descend" lastn="1">
        <$MTCustomConfigValue$>
    </MTCustomConfigLoop>

---------------------------------------

**MTCustomConfigName(Function Tag)**

Outputs 'Name' of the CustomConfig object in context.

*Example:*

    <MTCustomConfig key="ConfigFoo">
        <$MTCustomConfigName$>
    </MTCustomConfigLoop>
    
    # If CustomConfig object is { name => 'MTConfigFoo' , key=> 'ConfigFoo', value => 'FooValue' },
    # This template tag output 'MTConfigFoo'.
    
*In this case( an object name is begin with 'MT' ), custom function tag 'MTConfigFoo' is available. Example:*

    <$MTConfigFoo$> # => output 'FooValue'.
    
    <$MTConfigFoo column="key"$> # => output 'ConfigFoo'.

---------------------------------------

**MTFoo(Custom Function Tag)**

An object name is begin with 'MT'( ex. 'MTFoo' ), custom function tag 'MTCustomConfigName' is available.

*Attributes*

    column     : Outputs column value of the CustomConfig object
                 ( "id", "key", "value", "name"... ).
                 The default value is "value".

*Example:*

    <$MTFoo$>              # => output 'value' of CustomConfig object named 'MTFoo'.
    <$MTFoo column="key"$> # => output 'key' of CustomConfig object named 'MTFoo'.

---------------------------------------

**MTCustomConfigID(Function Tag)**

Outputs 'ID' of the CustomConfig object in context.

---------------------------------------

**MTCustomConfigPriority(Function Tag)**

Outputs 'Priority' of the CustomConfig object in context.

---------------------------------------

**MTCustomConfigValue(Function Tag)**

Outputs 'Value' of the CustomConfig object in context.

---------------------------------------

**MTCustomConfigKey(Function Tag)**

Outputs 'Key' of the CustomConfig object in context.

---------------------------------------

**MTCustomConfigCreatedOn(Function Tag)**

Outputs 'created_on' of the CustomConfig object in context.
[See the Date tag for supported attributes.](http://www.movabletype.org/documentation/appendices/tags/date.html)

---------------------------------------

**MTCustomConfigModifiedOn(Function Tag)**

Outputs 'modified_on' of the CustomConfig object in context.
[See the Date tag for supported attributes.](http://www.movabletype.org/documentation/appendices/tags/date.html)

---------------------------------------

**MTCustomConfigAuthorDisplayName(Function Tag)**

Outputs the display name of the author of the CustomConfig object in context.

---------------------------------------
