/**
 * Main API
 * No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
 *
 * The version of the OpenAPI document: 0.1.0
 *
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 *
 */

import ApiClient from '../ApiClient'

/**
 * The User model module.
 * @module model/User
 * @version 0.1.0
 */
class User {
  /**
   * Constructs a new <code>User</code>.
   * @alias module:model/User
   * @param id {Object} The ID of the user.
   * @param email {Object} The email address of the user.
   */
  constructor(id, email) {
    User.initialize(this, id, email)
  }

  /**
   * Initializes the fields of this object.
   * This method is used by the constructors of any subclasses, in order to implement multiple inheritance (mix-ins).
   * Only for internal use.
   */
  static initialize(obj, id, email) {
    obj['id'] = id
    obj['email'] = email
  }

  /**
   * Constructs a <code>User</code> from a plain JavaScript object, optionally creating a new instance.
   * Copies all relevant properties from <code>data</code> to <code>obj</code> if supplied or a new instance if not.
   * @param {Object} data The plain JavaScript object bearing properties of interest.
   * @param {module:model/User} obj Optional instance to populate.
   * @return {module:model/User} The populated <code>User</code> instance.
   */
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new User()

      if (data.hasOwnProperty('id')) {
        obj['id'] = ApiClient.convertToType(data['id'], Object)
      }
      if (data.hasOwnProperty('email')) {
        obj['email'] = ApiClient.convertToType(data['email'], Object)
      }
      if (data.hasOwnProperty('registeredAt')) {
        obj['registeredAt'] = ApiClient.convertToType(
          data['registeredAt'],
          Object,
        )
      }
      if (data.hasOwnProperty('total')) {
        obj['total'] = ApiClient.convertToType(data['total'], Object)
      }
      if (data.hasOwnProperty('equationData')) {
        obj['equationData'] = ApiClient.convertToType(
          data['equationData'],
          Object,
        )
      }
    }
    return obj
  }

  /**
   * Validates the JSON data with respect to <code>User</code>.
   * @param {Object} data The plain JavaScript object bearing properties of interest.
   * @return {boolean} to indicate whether the JSON data is valid with respect to <code>User</code>.
   */
  static validateJSON(data) {
    // check to make sure all required properties are present in the JSON string
    for (const property of User.RequiredProperties) {
      if (!data[property]) {
        throw new Error(
          'The required field `' +
            property +
            '` is not found in the JSON data: ' +
            JSON.stringify(data),
        )
      }
    }

    return true
  }
}

User.RequiredProperties = ['id', 'email']

/**
 * The ID of the user.
 * @member {Object} id
 */
User.prototype['id'] = undefined

/**
 * The email address of the user.
 * @member {Object} email
 */
User.prototype['email'] = undefined

/**
 * The date and time the user registered.
 * @member {Object} registeredAt
 */
User.prototype['registeredAt'] = undefined

/**
 * The total.
 * @member {Object} total
 */
User.prototype['total'] = undefined

/**
 * The equation data composed by the user.
 * @member {Object} equationData
 */
User.prototype['equationData'] = undefined

export default User
