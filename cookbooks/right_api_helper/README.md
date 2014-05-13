# right_api_helper cookbook

installs the `right_api_helper` gem and prerequisites

# Requirements

Attributes
----------
#### right_api_client::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['right_api_client']['user_email']</tt></td>
    <td>String</td>
    <td>the RightScale user's email address</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['right_api_client']['user_password']</tt></td>
    <td>String</td>
    <td>the RightScale user's password</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['right_api_client']['accound_id']</tt></td>
    <td>String</td>
    <td>the RightScale account ID</td>
    <td><tt>nil</tt></td>
  </tr>

</table>

Usage
-----
#### cas_portal::default
Just include `cas_portal::default` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[cas_portal::default]"
  ]
}

# Recipes

# Author

Author:: RightScale, Inc. (<cary@rightscale.com>)
