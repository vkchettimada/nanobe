# Nanobe
Seemingly smallest co-operative programming...

## Usage
```
void *_nanobe_main_sp;
void *_nanobe_0_sp;

uint8_t nanobe_0_stack[256];

void nanobe_0(void)
{
        printf("nanobe_0\n");
        while(1) {
                printf("switch to main, first\n");
                _nanobe_switch(_nanobe_main_sp, &_nanobe_0_sp);
                printf("switch to main, second\n");
                _nanobe_switch(_nanobe_main_sp, &_nanobe_0_sp);
        }
}

int main(void)
{
        printf("main\n");

        _nanobe_0_sp = _nanobe_init(nanobe_0,
				    nanobe_0_stack + sizeof(nanobe_0_stack));

        while (1) {
                printf("switch to nanobe_0\n");
                _nanobe_switch(_nanobe_0_sp, &_nanobe_main_sp);
        }
}
```
