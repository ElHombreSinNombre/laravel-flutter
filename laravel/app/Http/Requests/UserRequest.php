<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UserRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array|string>
     */
    public function rules(): array
    {
       return [
            'name' => ['sometimes', 'required', 'unique:users'],
            'email' => ['sometimes', 'required', 'email', 'unique:users'],
            'password' => ['sometimes', 'required'],
         ];
    }

    public function messages()
    {
        return [
            'name.required' => 'The name is required',
            'email.required' => 'The email is required',
            'password.required' => 'The password is required',
            'name.unique' => 'The name is already in use',
            'email.unique' => 'The email is already in use',
            'password.unique' => 'The password is already in use',
        ];
    }
}
