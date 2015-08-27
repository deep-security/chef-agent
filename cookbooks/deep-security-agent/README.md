deep-security-agent Cookbook
============================
A collection of recipes to help deploy and manage the Deep Security agent.

Requirements
------------
All of the recipes in this cookbook require a working Deep Security infrastructure. The key component is the Deep Security manager. The agents (which these recipes help you manager) do the heavy lifting but the manager gives the marching orders. 

There are no specific technical requirements beyond a standard Chef deployment.

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### deep-security-agent::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### deep-security-agent::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `deep-security-agent` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[deep-security-agent]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
