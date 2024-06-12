using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    public float speed = 5.0f;
    public float mouseSensitivity = 2.0f;
    public float gravity = -9.81f;
    public float jumpHeight = 1.5f;

    private Vector2 moveInput;
    private Vector2 lookInput;
    private bool jumpInput;
    private float verticalLookRotation;
    private CharacterController characterController;
    private Vector3 velocity;

    private void Awake()
    {
        characterController = GetComponent<CharacterController>();
    }

    public void OnMove(InputAction.CallbackContext context)
    {
        moveInput = context.ReadValue<Vector2>();
    }

    public void OnLook(InputAction.CallbackContext context)
    {
        lookInput = context.ReadValue<Vector2>();
    }

    public void OnJump(InputAction.CallbackContext context)
    {
        if (context.performed && characterController.isGrounded)
        {
            velocity.y = Mathf.Sqrt(jumpHeight * -2f * gravity);
        }
    }

    void OnControllerColliderHit(ControllerColliderHit hit)
    {
        // SprawdŸ, czy obiekt, z którym koliduje gracz, to szeœcian
        if (hit.collider.CompareTag("Cube"))
        {
            // Przesuñ szeœcian w tym samym kierunku i z t¹ sam¹ prêdkoœci¹, co gracz
            hit.collider.transform.Translate(characterController.velocity * Time.deltaTime);
        }
    }

    private void Update()
    {
        // Rotacja gracza
        transform.Rotate(Vector3.up * lookInput.x * mouseSensitivity);

        // Rotacja kamery
        verticalLookRotation += lookInput.y * mouseSensitivity;
        verticalLookRotation = Mathf.Clamp(verticalLookRotation, -90, 90);
        Camera.main.transform.localEulerAngles = Vector3.left * verticalLookRotation;

        // Ruch gracza
        Vector3 move = transform.right * moveInput.x + transform.forward * moveInput.y;
        characterController.Move(move * speed * Time.deltaTime);

        // Grawitacja
        if (characterController.isGrounded && velocity.y < 0)
        {
            velocity.y = -2f;
        }

        // Zawsze aktualizuj velocity o grawitacjê
        velocity.y += gravity * Time.deltaTime;
        characterController.Move(velocity * Time.deltaTime);
    }
}
