/* ========================================
   1. MENU RESPONSIVO
======================================== */

const botaoMenu = document.querySelector('.menu-toggle');
const menuPrincipal = document.querySelector('#menu-principal');

if (botaoMenu && menuPrincipal) {

    // Fecha o menu e restaura o botão.
    function fecharMenu() {
        menuPrincipal.classList.remove('aberto');

        botaoMenu.setAttribute('aria-expanded', 'false');
        botaoMenu.setAttribute('aria-label', 'Abrir menu');
        botaoMenu.textContent = '☰';
    }

    // Abre ou fecha o menu ao clicar no botão.
    botaoMenu.addEventListener('click', () => {
        const estaAberto = menuPrincipal.classList.toggle('aberto');

        botaoMenu.setAttribute(
            'aria-expanded',
            String(estaAberto)
        );

        botaoMenu.setAttribute(
            'aria-label',
            estaAberto ? 'Fechar menu' : 'Abrir menu'
        );

        botaoMenu.textContent = estaAberto ? '✕' : '☰';
    });

    // Fecha o menu quando um link é selecionado.
    menuPrincipal.querySelectorAll('a').forEach((link) => {
        link.addEventListener('click', fecharMenu);
    });

    // Fecha o menu com a tecla Escape.
    document.addEventListener('keydown', (evento) => {
        if (evento.key === 'Escape') {
            fecharMenu();
        }
    });

    // Fecha o menu ao voltar para a tela desktop.
    window.matchMedia('(min-width: 901px)').addEventListener(
        'change',
        (evento) => {
            if (evento.matches) {
                fecharMenu();
            }
        }
    );

    // Fecha o menu ao clicar fora dele.
    document.addEventListener('click', (evento) => {
        const clicouNoMenu = menuPrincipal.contains(evento.target);
        const clicouNoBotao = botaoMenu.contains(evento.target);

        if (!clicouNoMenu && !clicouNoBotao) {
            fecharMenu();
        }
    });
}


/* ========================================
   2. MODO CLARO E ESCURO
======================================== */

const botaoTema = document.querySelector('#tema-toggle');
const elementoHTML = document.documentElement;

if (botaoTema) {

    // Aplica o estado visual do botão com base no tema já definido no HTML
    function atualizarEstadoBotao(tema) {
        const temaClaro = tema === 'light';

        botaoTema.textContent = temaClaro ? '☾' : '☀';

        botaoTema.setAttribute(
            'aria-pressed',
            String(temaClaro)
        );

        // Atualiza a cor da barra do navegador no celular.
        const metaTema = document.querySelector(
            'meta[name="theme-color"]'
        );

        if (metaTema) {
            metaTema.setAttribute(
                'content',
                temaClaro ? '#f5f0e8' : '#0d0b0e'
            );
        }
    }

    // Inicializa o botão de acordo com o tema atual
    atualizarEstadoBotao(elementoHTML.dataset.theme || 'dark');

    // Alterna entre claro e escuro.
    botaoTema.addEventListener('click', () => {
        const temaAtual = elementoHTML.dataset.theme;

        const novoTema = temaAtual === 'dark'
            ? 'light'
            : 'dark';

        elementoHTML.dataset.theme = novoTema;
        atualizarEstadoBotao(novoTema);

        // Guarda a escolha para a próxima visita.
        try {
            localStorage.setItem('tema', novoTema);
        } catch (erro) {
            // A troca de tema continua funcionando sem armazenamento.
        }
    });
}